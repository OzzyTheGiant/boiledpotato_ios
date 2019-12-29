import XCTest
import PromiseKit
import Alamofire
@testable import Boiled_Potato

class RecipeRepositoryUnitTest : XCTestCase {
    fileprivate let daoMock = RecipeDAOMock()
    fileprivate let apiMock = RestAPIServiceMock(apiURL: "https://example.com/", apiKey: "1234")
    private var repository : RecipeRepository?
    private let timeoutSeconds : Double = 10
    
    var parameters : Parameters = [
        "query": "Chicken",
        "cuisine": "mexican",
        "number": 10,
        "offset": 0
    ]
    
    override func setUp() {
        repository = RecipeRepository(restApiService: apiMock, recipeDAO: daoMock)
    }
    
    private func searchRecipes(expectation: XCTestExpectation) {
        repository!.searchRecipes(queryData: parameters) { resource in
            XCTAssert(resource is Resource.Success)
            XCTAssertEqual(self.parameters["query"] as! String, resource.data!.searchKeywords)
            XCTAssertEqual(1, resource.data!.recipes!.count)
            expectation.fulfill()
        }
    }
    
    func testRepoGetsRecipesFromDB() {
        let expectation = XCTestExpectation(description: "Get cached recipes")
        daoMock.query.recipes = nil
        searchRecipes(expectation: expectation)
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testRepoGetsRecipesFromApiIfQueryNotCached() {
        let expectation = XCTestExpectation(description: "Get recipes from API")
        self.parameters["query"] = "Beef"
        searchRecipes(expectation: expectation)
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testRepoGetsRecipesFromApiIfQueryIsStale() {
        let expectation = XCTestExpectation(description: "Download recipes if query is stale")
        daoMock.query.expires = 0
        searchRecipes(expectation: expectation)
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testRepoReturnErrorResourceIfNoRecipesFound() {
        let expectation = XCTestExpectation(description: "Return Error Resource")
        self.parameters["query"] = "pork"
        
        repository!.searchRecipes(queryData: parameters) { resource in
            XCTAssert(resource is Resource.Error)
            XCTAssertEqual(resource.message!, DataError.noResultsFound.errorDescription!)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testRepoGetsRecipeDetails() {
        let expectation = XCTestExpectation(description: "Get recipe details")
        
        repository!.getDetails(for: daoMock.recipe) { resource in
            XCTAssert(resource is Resource.Success)
            XCTAssertEqual((resource.data! as Recipe).id, self.daoMock.recipe.id)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testRepoGetsFavoriteRecipes() {
        let expectation = XCTestExpectation(description: "Get favorite recipes")
        
        repository!.getFavoriteRecipes(queryData: parameters, getCount: true) { resource in
            XCTAssert(resource is Resource.Success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testRepoChecksIfRecipeIsFavorite() {
        let expectation = XCTestExpectation(description: "Check recipe is favorite")
        
        repository!.checkIsFavorite(recipeId: daoMock.recipe.id) { resource in
            XCTAssert(resource is Resource.Success)
            XCTAssert(resource.data!)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testRepoMarksRecipeAsFavorite() {
        let expectation = XCTestExpectation(description: "Mark recipe as favorite")
        
        repository!.toggleFavorite(on: true, recipeId: daoMock.recipe.id) { resource in
            XCTAssert(resource is Resource.Success)
            XCTAssert(resource.data!)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testRepoUnmarksRecipeAsFavorite() {
        let expectation = XCTestExpectation(description: "Unmark recipe as favorite")
        
        repository!.toggleFavorite(on: false, recipeId: daoMock.recipe.id) { resource in
            XCTAssert(resource is Resource.Success)
            XCTAssert(!resource.data!)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutSeconds)
    }
}

fileprivate class RecipeDAOMock : RecipeDAO {
    var query = TestData.sampleQuery
    var recipe = TestData.sampleRecipe
    
    init() {
        super.init(db: nil)
    }
    
    override func getSearchQuery(with keywords: String, filteredBy cuisine: String) -> Promise<RecipeSearchQuery> {
        if (keywords == "Chicken") {
            return .value(self.query)
        };  return .value(RecipeSearchQuery())
    }
    
    override func getRecipes(bySearchQuery query: RecipeSearchQuery, limit: Int, offset: Int) -> Promise<RecipeSearchQuery> {
        var query = query
        query.recipes = [recipe]
        return .value(query)
    }
    
    override func save(recipe: Recipe) -> Promise<Recipe> {
        return .value(self.recipe)
    }
    
    override func getFavoriteRecipes(resultSize: Int, offset: Int, getCount: Bool) -> Promise<RecipeSearchQuery> {
        return .value(self.query)
    }
    
    override func getFavorite(recipeId: Int) -> Promise<Bool> {
        return .value(true)
    }
    
    override func delete(favorite recipeId: Int) -> Promise<Bool> {
        return .value(false)
    }
    
    override func save(favorite recipeId: Int) -> Promise<Bool> {
        return .value(true)
    }
    
    override func saveAll(query: RecipeSearchQuery) -> Promise<Void> {
        return .value(())
    }
}

fileprivate class RestAPIServiceMock : RestApiService {
    private var query = TestData.sampleQuery
    private var recipe = TestData.sampleRecipe
    
    override func getRecipes(parameters: Parameters) -> Promise<RecipeSearchQuery> {
        if parameters["query"] as? String == "pork" {
            self.query.recipes = []
        } else {
            self.query.recipes = [recipe]
        }
        
        return .value(self.query)
    }
    
    override func getRecipe(byId id: CLong) -> Promise<Recipe> {
        return .value(self.recipe)
    }
}
