import SQLite

struct RecipeSchema {
    let table         = Table("Recipes")
    
    let id            = Expression<Int>("ID")
    let name          = Expression<String>("Name")
    let prepMinutes   = Expression<Int>("PrepMinutes")
    let imageFileName = Expression<String>("ImageFileName")
    let servings      = Expression<Int>("Servings")
    let ingredients   = Expression<String>("Ingredients")
    let instructions  = Expression<String>("Instructions")
}

struct FavoriteSchema {
    let table         = Table("Favorites")
    let recipeId      = Expression<Int>("RecipeId")
}
