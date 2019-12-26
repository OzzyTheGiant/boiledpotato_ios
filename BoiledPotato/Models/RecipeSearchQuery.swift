import SQLite
import PromiseKit

struct RecipeSearchQuery {
    var id : CLong = 0
    var searchKeywords : String = ""
    var cuisine: String = ""
    var totalResults : Int = 0
    var expires : CLong = 0
    var recipes : [Recipe]?
    
    var isStale : Bool {
        get { return Double(expires) < Date().timeIntervalSince1970 * 1000 }
    }
    
    init() {} // initiate with defaults
    
    init(id: CLong, keywords: String, cuisine: String, totalResults: Int, expires: CLong) {
        self.id = id
        self.searchKeywords = keywords
        self.cuisine = cuisine
        self.totalResults = totalResults
        self.expires = expires
    }
}

extension RecipeSearchQuery : Codable {
    // for decoding from JSON
    enum JSONKeys : String, CodingKey {
        case totalResults = "totalResults"
        case expires = "expires"
        case recipes = "results"
    }
    
    // for encoding to SQLite
    enum SQLiteKeys: String, CodingKey {
        case id = "ID"
        case searchKeywords = "Keywords"
        case cuisine = "Cuisine"
        case totalResults = "ResultAmount"
        case expires = "ExpirationTime"
    }
    
    /** for instantiating from JSON http request data */
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JSONKeys.self)
        totalResults  = try container.decode(Int.self, forKey: .totalResults)
        expires       = try container.decode(Int.self, forKey: .expires)
        recipes       = try container.decode([Recipe].self, forKey: .recipes)
    }
    
    /** for instantiating from SQLite Row object */
    init(from decoder: Decoder, madeBySQLite: Bool) throws {
        let container  = try decoder.container(keyedBy: SQLiteKeys.self)
        id             = try container.decode(Int.self, forKey: .id)
        searchKeywords = try container.decode(String.self, forKey: .searchKeywords)
        cuisine        = try container.decode(String.self, forKey: .cuisine)
        totalResults   = try container.decode(Int.self, forKey: .totalResults)
        expires        = try container.decode(Int.self, forKey: .expires)
    }
    
    /** for encoding to SQLite database */
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SQLiteKeys.self)
        
        if id != 0 {
            // save id to database if
            try container.encode(Int(id), forKey: .id)
        }
        
        try container.encode(searchKeywords, forKey: .searchKeywords)
        try container.encode(cuisine, forKey: .cuisine)
        try container.encode(totalResults, forKey: .totalResults)
        try container.encode(expires, forKey: .expires)
    }
}
