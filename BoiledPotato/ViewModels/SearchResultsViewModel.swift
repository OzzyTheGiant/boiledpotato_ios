import Foundation

class SearchResultsViewModel : NSObject {
    let repository: RecipeRepository
    let maxResultsSize = 10
    
    var searchKeywords : String = ""
    var cuisine : String = ""
    var recipes : [Recipe] = []
    var queryResult : Resource<RecipeSearchQuery> = Resource.Loading()
    
    // observable property to check if queryResult has changed
    @objc dynamic var queryObservable : Int = 0
    
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
        
        repository.searchRecipes(queryData: parameters) { resource in
            if resource is Resource.Success {
                self.recipes.append(contentsOf: resource.data!.recipes!)
            }
            
            self.queryResult = resource
            self.queryObservable += 1
        }
    }
}
