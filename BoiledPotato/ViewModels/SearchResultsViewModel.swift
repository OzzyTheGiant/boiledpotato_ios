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
        
        queryResult = Resource.Loading()
        self.queryObservable = !self.queryObservable
        
        repository.searchRecipes(queryData: parameters) { resource in
            if resource is Resource.Success {
                self.recipes.append(contentsOf: resource.data!.recipes!)
            }
            
            if self.totalResults == 0 {
                self.totalResults = resource.data?.totalResults ?? 0
            }
            
            if resource.data?.totalResults == 0 {
                // set error message if result set is empty
                self.queryResult = Resource.Error(NSLocalizedString("NO_DATA_ERROR", comment: ""))
            } else {
                self.queryResult = resource
            }
            
            self.queryObservable = !self.queryObservable
        }
    }
}
