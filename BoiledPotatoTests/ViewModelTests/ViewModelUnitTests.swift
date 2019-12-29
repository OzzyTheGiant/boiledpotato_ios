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

fileprivate class RecipeRepositoryMock : RecipeRepository {
    var query = TestData.sampleQuery
    let recipe = TestData.sampleRecipe
    
    override init(restApiService: RestApiService, recipeDAO: RecipeDAO) {
        super.init(restApiService: restApiService, recipeDAO: recipeDAO)
        query.recipes = [recipe]
    }
    
    override func searchRecipes(queryData: Parameters, onComplete complete: @escaping RecipeRepository.Handler<RecipeSearchQuery>) {
        if queryData["query"] as! String == "Beef" {
            return complete(Resource.Error("Test Error"))
        };  complete(Resource.Success(query))
    }
}
