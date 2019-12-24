class RecipeSearchResult {
    var queryId : CLong = 0
    var recipeId : CLong = 0
    
    init(queryId: CLong, recipeId: CLong) {
        self.queryId = queryId
        self.recipeId = recipeId
    }
}

extension RecipeSearchResult : Encodable {
    enum CodingKeys : String, CodingKey {
        case queryId = "QueryID"
        case recipeId = "RecipeID"
    }
}
