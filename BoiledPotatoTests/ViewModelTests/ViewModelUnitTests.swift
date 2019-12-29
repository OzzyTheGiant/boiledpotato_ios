import XCTest
import Alamofire
@testable import Boiled_Potato

class SearchResultViewModelUnitTest : XCTestCase {
    fileprivate var repositoryMock : RecipeRepositoryMock?
    var viewModel : SearchResultsViewModel?
    let timeoutSeconds : Double = 10
    
    override func setUp() {
        repositoryMock = RecipeRepositoryMock(restApiService: RestAPIServiceMock(apiURL: "", apiKey: ""), recipeDAO: RecipeDAOMock())
        viewModel = SearchResultsViewModel(repository: repositoryMock!)
    }
    
    func testViewModelGetsSearchQuery() {
        viewModel?.fetchRecipes()
        XCTAssert(viewModel!.queryResult is Resource.Success)
        XCTAssertEqual(viewModel!.queryResult.data!.id, repositoryMock!.query.id)
        XCTAssertEqual(viewModel!.queryResult.data!.recipes!.count, self.repositoryMock!.query.recipes!.count)
        XCTAssert(!viewModel!.queryObservable)
    }
    
    func testViewModelGetsErrorResource() {
        viewModel!.searchKeywords = "Beef"
        viewModel!.fetchRecipes()
        XCTAssert(viewModel!.queryResult is Resource.Error)
        XCTAssertEqual(viewModel!.queryResult.message, "Test Error")
        XCTAssert(!viewModel!.queryObservable)
    }
}

class RecipeViewModelUnitTest : XCTestCase {
    fileprivate var repositoryMock : RecipeRepositoryMock?
    var viewModel : RecipeViewModel?
    let timeoutSeconds : Double = 10
    
    override func setUp() {
        repositoryMock = RecipeRepositoryMock(restApiService: RestAPIServiceMock(apiURL: "", apiKey: ""), recipeDAO: RecipeDAOMock())
        viewModel = RecipeViewModel(repository: repositoryMock!)
        viewModel!.recipe = repositoryMock!.recipe
    }
    
    func testViewModelGetsRecipeDetails() {
        viewModel!.fetchRecipeDetails()
        XCTAssert(viewModel!.queryResult is Resource.Success)
        XCTAssertEqual(viewModel!.recipe.name, viewModel!.queryResult.data!.name)
        XCTAssert(viewModel!.queryObservable)
    }
    
    func testViewModelGetsErrorResource() {
        viewModel!.recipe.name = "Burger"
        viewModel!.fetchRecipeDetails()
        XCTAssert(viewModel!.queryResult is Resource.Error)
        XCTAssert(viewModel!.queryObservable)
    }
    
    func testViewModelDoesNothingIfRecipeNotFavorite() {
        viewModel!.checkIfRecipeIsFavorite()
        XCTAssert(viewModel!.favoriteResult is Resource.Loading)
        XCTAssert(!viewModel!.recipe.isFavorite)
        XCTAssert(!viewModel!.favoriteObservable)
    }
    
    func testViewModelUpdatesFavoriteStatusOnFirstCheck() {
        viewModel!.recipe.id = 1
        viewModel!.checkIfRecipeIsFavorite()
        XCTAssert(viewModel!.favoriteResult is Resource.Success)
        XCTAssert(viewModel!.favoriteResult.data!)
        XCTAssert(viewModel!.favoriteObservable)
        XCTAssert(viewModel!.recipe.isFavorite)
    }
    
    func testViewModelTogglesFavoriteStatus() {
        viewModel!.toggleRecipeAsFavorite()
        XCTAssert(viewModel!.favoriteResult is Resource.Success)
        XCTAssert(viewModel!.favoriteResult.data!)
        XCTAssert(viewModel!.favoriteObservable)
        XCTAssert(viewModel!.recipe.isFavorite)
    }
}

fileprivate class RecipeRepositoryMock : RecipeRepository {
    var query = TestData.sampleQuery
    var recipe = TestData.sampleRecipe
    
    override init(restApiService: RestApiService, recipeDAO: RecipeDAO) {
        super.init(restApiService: restApiService, recipeDAO: recipeDAO)
        query.recipes = [recipe]
    }
    
    override func searchRecipes(queryData: Parameters, onComplete complete: @escaping RecipeRepository.Handler<RecipeSearchQuery>) {
        if queryData["query"] as! String == "Beef" {
            return complete(Resource.Error("Test Error"))
        };  complete(Resource.Success(query))
    }
    
    override func getDetails(for recipe: Recipe, onComplete complete: @escaping RecipeRepository.Handler<Recipe>) {
        if recipe.name == "Burger" {
            return complete(Resource.Error("Test Error"))
        };  complete(Resource.Success(recipe))
    }
    
    override func checkIsFavorite(recipeId: CLong, onComplete complete: @escaping RecipeRepository.Handler<Bool>) {
        if recipeId == 1 {
            return complete(Resource.Success(true))
        }; complete(Resource.Success(false))
    }
    
    override func toggleFavorite(on: Bool, recipeId: CLong, onComplete complete: @escaping RecipeRepository.Handler<Bool>) {
        complete(Resource.Success(on))
    }
}
