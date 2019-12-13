struct RecipeSearchQuery {
    var id : CLong = 0
    var searchKeywords : String = ""
    var cuisine: String = ""
    var totalResults : Int = 0
    var expires : CLong = 0
    var recipes : [Recipe]?
    
    init(id: CLong, keywords: String, cuisine: String, totalResults: Int, expires: CLong) {
        self.id = id
        self.searchKeywords = keywords
        self.cuisine = cuisine
        self.totalResults = totalResults
        self.expires = expires
    }
}

extension RecipeSearchQuery : Decodable {
    enum CodingKeys : String, CodingKey {
        case totalResults = "totalResults"
        case expires = "expires"
        case recipes = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        self.expires = try container.decode(Int.self, forKey: .expires)
        self.recipes = try container.decode([Recipe].self, forKey: .recipes)
    }
}
