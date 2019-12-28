import XCTest
import SQLite
import PromiseKit
@testable import Boiled_Potato

class RecipeDAOUnitTest : XCTestCase {
    var db : Connection?
    var recipeDAO : RecipeDAO?
    
    var query = TestData.sampleQuery
    var recipe = TestData.sampleRecipe
    
    var setUpPromise : Promise<Void>?
    let timeoutSeconds : Double = 10
    
    override func setUp() {
        recipeDAO = RecipeDAO(db: try? Connection(.inMemory))
        query.id = 0
        query.recipes = [recipe]
        setUpPromise = recipeDAO!.saveAll(query: query)
    }
    
    func testDAOGetsCachedSearchQuery() {
        let expectation = XCTestExpectation(description: "Fetch cached SearchQuery")
        
        setUpPromise!.then { _ -> Promise<RecipeSearchQuery> in
            self.recipeDAO!.getSearchQuery(with: self.query.searchKeywords, filteredBy: self.query.cuisine)
        }
        
        .done { query in
            XCTAssertEqual(1, query.id, "ID's not matching")
            XCTAssertEqual(self.query.totalResults, query.totalResults, "Total results not matching")
            XCTAssertEqual(self.query.expires, query.expires, "Expires not matching")
            expectation.fulfill()
        }
        
        .catch { error in
            XCTFail(error.localizedDescription)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testDAOMakesNewSearchQueryIfNoneFound() {
        let expectation = XCTestExpectation(description: "Get new search query object")
        
        setUpPromise!.then { _ -> Promise<RecipeSearchQuery> in
            self.recipeDAO!.getSearchQuery(with: "beef", filteredBy: "")
        }
        
        .done { query in
            XCTAssertEqual(0, query.id, "ID's not matching")
            XCTAssertEqual(0, query.totalResults, "Total results not matching")
            XCTAssertEqual(0, query.expires, "Expires not matching")
            expectation.fulfill()
        }
        
        .catch { error in
            XCTFail(error.localizedDescription)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }

    func testDAOGetsRecipes() {
        let expectation = XCTestExpectation(description: "Fetch cached recipe")
        query.recipes = nil
        query.id = 1
        
        setUpPromise!.then { _ -> Promise<RecipeSearchQuery> in
            self.recipeDAO!.getRecipes(bySearchQuery: self.query, limit: 10, offset: 0)
        }
        
        .done { query in
            XCTAssertEqual(1, query.recipes?.count, "recipe count not matching")
            XCTAssertEqual(query.recipes?[0].id, self.recipe.id)
            XCTAssertEqual(query.recipes?[0].name, self.recipe.name)
            XCTAssertEqual(query.recipes?[0].servings, self.recipe.servings)
            XCTAssertEqual(query.recipes?[0].prepMinutes, self.recipe.prepMinutes)
            XCTAssertEqual(query.recipes?[0].imageFileName, self.recipe.imageFileName)
            expectation.fulfill()
        }
        
        .catch { error in
            XCTFail(error.localizedDescription)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testDAOReturnsQueryWithNoRecipes() {
        let expectation = XCTestExpectation(description: "Return empty recipe array")
        query.recipes = nil
        
        setUpPromise!.then { _ -> Promise<RecipeSearchQuery> in
            self.recipeDAO!.getRecipes(bySearchQuery: self.query, limit: 10, offset: 0)
        }
        
        .done { query in
            XCTAssertEqual(0, query.recipes?.count, "recipe count not matching")
            expectation.fulfill()
        }
        
        .catch { error in
            XCTFail(error.localizedDescription)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testDAOSavesRecipe() {
        let expectation = XCTestExpectation(description: "Save recipe")
        self.recipe.servings = 5
        self.query.id = 1
        
        setUpPromise!.then { _ -> Promise<Recipe> in
            self.recipeDAO!.save(recipe: self.recipe)
        }
            
        .then { _ in
            self.recipeDAO!.getRecipes(bySearchQuery: self.query, limit: 10, offset: 0)
        }
            
        .done { query in
            XCTAssertEqual(self.recipe.servings, query.recipes?[0].servings)
            expectation.fulfill()
        }
        
        .catch { error in
            XCTFail(error.localizedDescription)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testDAOSavesAndConfirmsFavoriteRecipe() {
        let expectation = XCTestExpectation(description: "Save favorite recipe")
        self.recipe.isFavorite = true
        
        setUpPromise!.then { _ -> Promise<Bool> in
            self.recipeDAO!.save(favorite: self.recipe.id)
        }
        
        .then { _ -> Promise<Bool> in
            self.recipeDAO!.getFavorite(recipeId: self.recipe.id)
        }
        
        .done {
            isFavorite in XCTAssert(isFavorite)
            expectation.fulfill()
        }
            
        .catch { error in
            XCTFail(error.localizedDescription)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }

    func testDAOSavesAndRetrievesMultipleFavoriteRecipes() {
        let expectation = XCTestExpectation(description: "Save multiple favorite recipes")
        
        setUpPromise!.then { _ -> Promise<Bool> in
            self.recipeDAO!.save(favorite: self.recipe.id)
        }
        
        .then { _ -> Promise<Void> in
            self.recipe.id = 100200
            self.query.recipes = [self.recipe]
            return self.recipeDAO!.saveAll(query: self.query)
        }
            
        .then { _ -> Promise<Bool> in
            self.recipeDAO!.save(favorite: self.recipe.id)
        }
        
        .then { _ -> Promise<RecipeSearchQuery> in
            self.recipeDAO!.getFavoriteRecipes(resultSize: 10, offset: 0, getCount: true)
        }
        
        .done { query in
            XCTAssertEqual(2, query.totalResults)
            XCTAssertEqual(2, query.recipes?.count)
            XCTAssertEqual(query.recipes?[0].id, 100100)
            XCTAssertEqual(query.recipes?[1].id, 100200)
            XCTAssertEqual(query.recipes?[0].name, self.recipe.name)
            XCTAssertEqual(query.recipes?[1].name, self.recipe.name)
            expectation.fulfill()
        }
        
        .catch { error in
            XCTFail(error.localizedDescription)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testDAODeletesRecipeFromFavorites() {
        let expectation = XCTestExpectation(description: "Delete favorite recipe")
        
        setUpPromise!.then { _ -> Promise<Bool> in
            self.recipeDAO!.save(favorite: self.recipe.id)
        }
        
        .then { _ -> Promise<Bool> in
            self.recipeDAO!.delete(favorite: self.recipe.id)
        }
            
        .then { _ -> Promise<Bool> in
            self.recipeDAO!.getFavorite(recipeId: self.recipe.id)
        }
        
        .done { isFavorite in
            XCTAssert(!isFavorite)
            expectation.fulfill()
        }
        
        .catch { error in
            XCTFail(error.localizedDescription)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
}
