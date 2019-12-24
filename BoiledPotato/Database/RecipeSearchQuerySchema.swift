import SQLite

struct RecipeSearchQuerySchema {
    let table          = Table("SearchQueries")
    
    let id             = Expression<Int>("ID")
    let searchKeywords = Expression<String>("Keywords")
    let cuisine        = Expression<String>("Cuisine")
    let totalResults   = Expression<Int>("ResultAmount")
    let expires        = Expression<Int>("ExpirationTime")
}
