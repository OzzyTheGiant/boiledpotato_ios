import Foundation
import SQLite

struct Recipe {
    var id: CLong = 0
    var name: String = ""
    var prepMinutes: Int = 0
    var imageFileName: String = ""
    var servings: Int = 0
    var isFavorite: Bool = false
    var ingredients: [String]? = nil
    var instructions: [String]? = nil
    
    init() {}
    
    init(id: CLong, name: String, prepMinutes: Int, image: String, servings: Int = 0, ingredients: [String]?, instructions: [String]?) {
        self.id = id
        self.name = name
        self.prepMinutes = prepMinutes
        self.imageFileName = image
        self.ingredients = ingredients
        self.instructions = instructions
        self.servings = servings
    }
}

extension Recipe : Codable {
    enum JSONKeys : String, CodingKey {
        case id = "id"
        case name = "title"
        case prepMinutes = "readyInMinutes"
        case imageFileName = "image"
        case ingredients = "extendedIngredients"
        case instructions = "analyzedInstructions"
        case servings = "servings"
    }
    
    enum SQLiteKeys : String, CodingKey {
        case id = "ID"
        case name = "Name"
        case prepMinutes = "PrepMinutes"
        case imageFileName = "ImageFileName"
        case servings = "Servings"
        case ingredients = "Ingredients"
        case instructions = "Instructions"
    }
    
    /** for decoding data from JSON http request data */
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JSONKeys.self)
        
        // If recipe object has ingredient and instruction data, decode it according to the
        // structs provided at the bottom of the file
        let ingredientsMetadata  = try? container.decode([IngredientsMetadata].self, forKey: .ingredients)
        let instructionsMetadata = try? container.decode([InstructionsMetadata].self, forKey: .instructions)
        
        // API ingredient text data is found under "originalString" key for each ingredient object
        // This is similar for instructions but it has nested arrays of objects
        let ingredients = ingredientsMetadata?.map { $0.originalString }
        let instructions = instructionsMetadata?.flatMap { $0.steps.map { $0.step } }
        
        self.init(
            id:           try container.decode(CLong.self, forKey: .id),
            name:         try container.decode(String.self, forKey: .name),
            prepMinutes:  try container.decode(Int.self, forKey: .prepMinutes),
            image:        try container.decode(String.self, forKey: .imageFileName),
            servings:     try container.decode(Int.self, forKey: .servings),
            ingredients:  ingredients,
            instructions: instructions
        )
    }
    
    /** for decoding data from SQLite */
    init(from decoder: Decoder, madeBySQLite: Bool) throws {
        let container = try decoder.container(keyedBy: SQLiteKeys.self)
        
        let ingredients  = try container.decode(String.self, forKey: .ingredients)
        let instructions = try container.decode(String.self, forKey: .instructions)
        
        self.init(
            id:           try container.decode(CLong.self, forKey: .id),
            name:         try container.decode(String.self, forKey: .name),
            prepMinutes:  try container.decode(Int.self, forKey: .prepMinutes),
            image:        try container.decode(String.self, forKey: .imageFileName),
            servings:     try container.decode(Int.self, forKey: .servings),
            ingredients:  ingredients == "" ? ingredients.components(separatedBy: "#!") : nil,
            instructions: instructions == "" ? instructions.components(separatedBy: "#!") : nil
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SQLiteKeys.self)
        try container.encode(Int(id), forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(prepMinutes, forKey: .prepMinutes)
        try container.encode(imageFileName, forKey: .imageFileName)
        try container.encode(servings, forKey: .servings)
        
        let reducer = { result, item in
            // combine all strings into one, delimited by a substring
            return result + item + "#!"
        }
        
        let ingredients = self.ingredients?.reduce("", reducer) ?? ""
        let instructions = self.instructions?.reduce("", reducer) ?? ""
        
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(instructions, forKey: .instructions)
    }
}

fileprivate struct IngredientsMetadata : Decodable {
    let originalString : String
}

fileprivate struct InstructionsMetadata : Decodable {
    let steps : [StepsMetadata]
}

fileprivate struct StepsMetadata : Decodable {
    let step : String
}
