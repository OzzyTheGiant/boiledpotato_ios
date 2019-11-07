import Alamofire

class RecipeRepository {
    private let apiService: RestApiService
    
    init(restApiService: RestApiService) {
        apiService = restApiService
    }
    
    func searchRecipes(queryData: Parameters, onComplete handler: @escaping RestApiService.CompleteHandler) {
        apiService.getRecipes(parameters: queryData, onCompletion: handler)
    }
}
