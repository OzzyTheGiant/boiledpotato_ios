import Alamofire

class RecipeRepository {
    // a short type alias for callbacks from viewmodel, which accept a data Resource
    typealias Handler<T> = RestApiService.CompleteHandler<T>
    
    private let apiService: RestApiService
    
    init(restApiService: RestApiService) {
        apiService = restApiService
    }
    
    func searchRecipes(queryData: Parameters, onComplete handler: @escaping Handler<RecipeSearchQuery>) {
        apiService.getRecipes(parameters: queryData, onCompletion: handler)
    }
    
    func getRecipe(byId id: CLong, onComplete handler: @escaping Handler<Recipe>) {
        apiService.getRecipe(byId: id, onCompletion: handler)
    }
}
