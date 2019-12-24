import Alamofire
import PromiseKit

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
    
    private func resolvePromise<T>(with response: DataResponse<T, AFError>, and resolver: Resolver<T>) {
        switch response.result {
            case .success: resolver.fulfill(response.value!)
            case .failure: resolver.reject(response.error!.underlyingError!)
        }
    }
    
    func getRecipes(parameters: Parameters) -> Promise<RecipeSearchQuery> {
        return Promise { resolver in
            AF
            .request(baseURL + "/recipes/search", parameters: parameters, headers: headers)
            .validate().responseDecodable(of: RecipeSearchQuery.self) { response in
                self.resolvePromise(with: response, and: resolver)
            }
        }
    }
    
    func getRecipe(byId id: CLong) -> Promise<Recipe> {
        return Promise { resolver in
            AF
            .request(baseURL + "/recipes/\(id)/information", headers: headers)
            .validate().responseDecodable(of: Recipe.self) { response in
                self.resolvePromise(with: response, and: resolver)
            }
        }
    }
}
