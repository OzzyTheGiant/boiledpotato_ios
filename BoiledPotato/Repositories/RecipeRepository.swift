import Alamofire
import PromiseKit

class RecipeRepository {
    // a short type alias for callbacks from viewmodel, which accept a data Resource
    typealias Handler<T> = (Resource<T>) -> Void
    
    private let apiService: RestApiService
    private let recipeDAO: RecipeDAO
    
    init(restApiService: RestApiService, recipeDAO: RecipeDAO) {
        self.apiService = restApiService
        self.recipeDAO = recipeDAO
    }
    
    func searchRecipes(queryData: Parameters, onComplete complete: @escaping Handler<RecipeSearchQuery>) {
        let keywords = queryData["query"] as! String
        let cuisine = queryData["cuisine"] as! String
        
        firstly { recipeDAO.getSearchQuery(with: keywords, filteredBy: cuisine) }
        
        .then { query -> Promise<RecipeSearchQuery> in
            let number = queryData["number"] as! Int
            let offset = queryData["offset"] as! Int
            
            if !query.isStale {
                // if query was previously made and is not stale, get recipes in database
                return self.recipeDAO.getRecipes(bySearchQuery: query, limit: number, offset: offset)
            };  return .value(query)
        }
        
        .then { query -> Promise<RecipeSearchQuery> in
            // Check if data is stale or no recipes found for a search query
            if query.isStale || query.recipes?.isEmpty ?? true {
                return self.apiService.getRecipes(parameters: queryData)
            };  return .value(query)
        }
        
        .done { query in
            var query = query // convert let to var
            
            // save data if this query is not cached in database
            if query.id == 0 {
                query.searchKeywords = keywords
                query.cuisine = cuisine
                _ = self.recipeDAO.saveAll(query: query)
            }
            
            // check if no results came back and create Resource accordingly
            if query.totalResults == 0 || query.recipes!.isEmpty {
                throw(DataError.noResultsFound)
            };  complete(Resource.Success(query))
        }
        
        .catch { error in
            print(error)
            complete(Resource.Error(error.localizedDescription))
        }
    }
    
    func getDetails(for recipe: Recipe, onComplete complete: @escaping Handler<Recipe>) {
        firstly { apiService.getRecipe(byId: recipe.id) }
            
        .then { updatedRecipe -> Promise<Recipe> in
            var updatedRecipe = updatedRecipe
            
            // change image file name because the previous api endpoint returns a full url
            // when the app only needs the file name by itself
            updatedRecipe.imageFileName = recipe.imageFileName
            return self.recipeDAO.save(recipe: updatedRecipe)
        }
        
        .done { recipe in complete(Resource.Success(recipe)) }
        
        .catch { error in
            print(error)
            complete(Resource.Error(error.localizedDescription))
        }
    }
    
    func checkIsFavorite(recipeId: CLong, onComplete complete: @escaping Handler<Bool>) {
        firstly { recipeDAO.getFavorite(recipeId: recipeId) }
        
        .done { isFavorite in complete(Resource.Success(isFavorite)) }
            
        .catch { error in
            print(error)
            complete(Resource.Error(error.localizedDescription))
        }
    }
    
    func toggleFavorite(on: Bool, recipeId: CLong, onComplete complete: @escaping Handler<Bool>) {
        let promise : Promise<Bool>
        
        if on {
            promise = recipeDAO.save(favorite: recipeId)
        } else {
            promise = recipeDAO.delete(favorite: recipeId)
        }
        
        promise.done { isFavorite in complete(Resource.Success(isFavorite)) }
        
        .catch { error in
            print(error)
            complete(Resource.Error(error.localizedDescription))
        }
    }
}
