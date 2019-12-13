import Foundation

class RecipeViewModel : NSObject {
    var recipe : Recipe!
    let repository : RecipeRepository
    var queryResult : Resource<Recipe> = Resource.Loading()
    
    // observable property to check if queryResult has changed
    @objc dynamic var queryObservable : Bool = false
    
    init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    func fetchRecipeDetails() {
        repository.getRecipe(byId: recipe.id) { resource in
            if resource is Resource.Success {
                self.recipe.servings = resource.data!.servings
                self.recipe.ingredients = resource.data!.ingredients
                self.recipe.instructions = resource.data!.instructions
            }
            
            self.queryResult = resource
            self.queryObservable = !self.queryObservable
        }
    }
}
