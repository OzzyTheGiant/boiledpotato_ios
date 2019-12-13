import Alamofire

class RestApiService {
    typealias CompleteHandler<T> = (Resource<T>) -> Void
    
    let baseURL: String
    let headers: HTTPHeaders
    
    init(apiURL: String, apiKey: String) {
        self.baseURL = "https://" + apiURL
        self.headers = [
            "X-RapidAPI-Host": apiURL,
            "X-RapidAPI-Key": apiKey
        ]
    }
    
    private func createResource<T>(response: DataResponse<T, AFError>) -> Resource<T> {
        switch response.result {
            case .success: return Resource.Success(response.value!)
            case .failure: return Resource.Error(response.error!.underlyingError?.localizedDescription ?? "")
        }
    }
    
    func getRecipes(parameters: Parameters, onCompletion handler: @escaping CompleteHandler<RecipeSearchQuery>) {
        AF
        .request(baseURL + "/recipes/search", parameters: parameters, headers: headers)
        .validate().responseDecodable(of: RecipeSearchQuery.self) { response in
            handler(self.createResource(response: response))
        }
    }
    
    func getRecipe(byId id: CLong, onCompletion handler: @escaping CompleteHandler<Recipe>) {
        AF
        .request(baseURL + "/recipes/\(id)/information", headers: headers)
        .validate().responseDecodable(of: Recipe.self) { response in
            handler(self.createResource(response: response))
        }
    }
}
