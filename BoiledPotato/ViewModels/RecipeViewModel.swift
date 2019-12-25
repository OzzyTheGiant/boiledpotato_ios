import Foundation

class RecipeViewModel : NSObject {
    var recipe : Recipe!
    let repository : RecipeRepository
    var queryResult : Resource<Recipe>  = Resource.Loading()
    var favoriteResult : Resource<Bool> = Resource.Loading()
    
    // observable property to check if queryResult has changed
    @objc dynamic var queryObservable : Bool = false
    @objc dynamic var favoriteObservable : Bool = false
    
    init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    @objc func fetchRecipeDetails() {
        // check if this is an attempt to retry to load after an error
        if !(queryResult is Resource.Loading) {
            queryResult = Resource.Loading()
            queryObservable = !queryObservable
        }
        
        repository.getDetails(for: recipe) { resource in
            if resource is Resource.Success {
                self.recipe.servings = resource.data!.servings
                self.recipe.ingredients = resource.data!.ingredients
                self.recipe.instructions = resource.data!.instructions
            }
            
            self.queryResult = resource
            self.queryObservable = !self.queryObservable
        }
    }
    
    @objc func checkIfRecipeIsFavorite() {
        repository.checkIsFavorite(recipeId: recipe.id) { resource in
            // only update viewcontroller if a recipe was previously marked as favorite
            if self.recipe.isFavorite != resource.data! {
                self.updateFavoriteStatus(with: resource)
            }
        }
    }
    
    @objc func toggleRecipeAsFavorite() {
        repository.toggleFavorite(on: !recipe.isFavorite, recipeId: recipe.id) { resource in
            self.updateFavoriteStatus(with: resource)
        }
    }
    
    private func updateFavoriteStatus(with resource: Resource<Bool>) {
        if resource is Resource.Success {
            self.recipe.isFavorite = resource.data!
        }
        
        self.favoriteResult = resource
        self.favoriteObservable = !self.favoriteObservable
    }
}
