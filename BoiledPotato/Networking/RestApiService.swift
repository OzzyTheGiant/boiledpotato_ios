import Alamofire

class RestApiService {
    typealias CompleteHandler = (Resource<RecipeSearchQuery>) -> Void
    
    let baseURL: String
    let headers: HTTPHeaders
    
    init(apiURL: String, apiKey: String) {
        self.baseURL = "https://" + apiURL
        self.headers = [
            "X-RapidAPI-Host": apiURL,
            "X-RapidAPI-Key": apiKey
        ]
    }
    
    private func onCompletion(response: DataResponse<RecipeSearchQuery, AFError>, handler: @escaping CompleteHandler) {
        switch response.result {
            case .success: handler(Resource.Success(response.value!))
            case .failure: handler(Resource.Error(response.error!.underlyingError?.localizedDescription ?? ""))
        }
    }
    
    func getRecipes(parameters: Parameters, onCompletion handler: @escaping CompleteHandler) {
        AF
        .request(baseURL + "/recipes/search", parameters: parameters, headers: headers)
        .validate().responseDecodable(of: RecipeSearchQuery.self) { response in
            self.onCompletion(response: response, handler: handler)
        }
    }
}
