import Foundation

class SearchResultsViewModel : NSObject {
    private let repository: RecipeRepository
    let maxResultsSize = 10
    
    var searchKeywords : String = ""
    var cuisine : String = ""
    var recipes : [Recipe] = []
    var totalResults : Int = 0
    var queryResult : Resource<RecipeSearchQuery> = Resource.Loading()
    
    // observable property to check if queryResult has changed
    @objc dynamic var queryObservable : Bool = false
    
    init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    func fetchRecipes() {
        // setup Alamofire request parameters
        let parameters: [String: Any] = [
            "query": searchKeywords,
            "cuisine": cuisine,
            "number": maxResultsSize,
            "offset": recipes.count
        ]
        
        self.queryResult = Resource.Loading()
        self.queryObservable = !self.queryObservable
        
        if searchKeywords == "favorites" {
            repository.getFavoriteRecipes(queryData: parameters, getCount: totalResults == 0) { resource in
                self.updateRecipeList(using: resource)
            }
        } else {
            repository.searchRecipes(queryData: parameters) { resource in
                self.updateRecipeList(using: resource)
            }
        }
    }
    
    private func updateRecipeList(using resource: Resource<RecipeSearchQuery>) {
        if resource is Resource.Success {
            let data = resource.data!
            
            self.totalResults = self.totalResults == 0 ? data.totalResults : 0
            self.recipes.append(contentsOf: data.recipes!)
        }
        
        self.queryResult = resource
        self.queryObservable = !self.queryObservable
    }
}
