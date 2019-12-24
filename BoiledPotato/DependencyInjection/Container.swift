import Swinject
import SQLite
import Foundation

extension AppDelegate {
    class func createContainer() -> Container {
        let container = Container()
        let imageBaseUrl = "https://spoonacular.com/recipeImages/"
        
        container.register(RecipeDAO.self) { resolver in
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let db = try? Connection("\(path)/BoiledPotato.sqlite3")
            return RecipeDAO(db: db)
        }.inObjectScope(.container)
        
        container.register(RestApiService.self) { resolver in
            let url, key : String
            
            do {
                let path = Bundle.main.path(forResource: "Config", ofType: "json")!
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: String]
                    
                url = json["webApiUrl"]! ; key = json["webApiKey"]!
            } catch {
                url = ""; key = ""
            }
            
            return RestApiService(apiURL: url, apiKey: key)
        }.inObjectScope(.container)
        
        container.register(RecipeRepository.self) { resolver in
            let apiService = resolver.resolve(RestApiService.self)!
            let recipeDAO = resolver.resolve(RecipeDAO.self)!
            return RecipeRepository(restApiService: apiService, recipeDAO: recipeDAO)
        }.inObjectScope(.container)
        
        container.register(SearchResultsViewModel.self) { resolver in
            let repository = resolver.resolve(RecipeRepository.self)!
            return SearchResultsViewModel(repository: repository)
        }
        
        container.register(RecipeViewModel.self) { resolver in
            let repository = resolver.resolve(RecipeRepository.self)!
            return RecipeViewModel(repository: repository)
        }
        
        container.register(SearchResultsViewController.self) { resolver in
            let viewModel = resolver.resolve(SearchResultsViewModel.self)!
            return SearchResultsViewController(viewModel: viewModel, imageBaseUrl: imageBaseUrl)
        }
        
        container.register(RecipeViewController.self) { resolver in
            let viewModel = resolver.resolve(RecipeViewModel.self)!
            return RecipeViewController(viewModel: viewModel, imageBaseUrl: imageBaseUrl)
        }

        return container
    }
}
