import SQLite

struct RecipeSearchResultsSchema {
    let table = Table("SearchResults")
    
    let queryId = Expression<Int>("QueryID")
    let recipeId = Expression<Int>("RecipeID")
}
