import Foundation

@objc class RecipeViewModel : NSObject {
    var recipe : Recipe!
    let repository : RecipeRepository
    
    // observable property to check if queryResult has changed
    @objc dynamic var queryObservable : Bool = false
    
    init(repository: RecipeRepository) {
        self.repository = repository
    }
}
