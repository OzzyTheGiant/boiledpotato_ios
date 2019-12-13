import Foundation

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
    
    init(id: CLong, name: String, prepMinutes: Int, image: String, ingredients: [String]?, instructions: [String]?, servings: Int = 0) {
        self.id = id
        self.name = name
        self.prepMinutes = prepMinutes
        self.imageFileName = image
        self.ingredients = ingredients
        self.instructions = instructions
        self.servings = servings
    }
}

extension Recipe : Decodable {
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "title"
        case prepMinutes = "readyInMinutes"
        case imageFileName = "image"
        case ingredients = "extendedIngredients"
        case instructions = "analyzedInstructions"
        case servings = "servings"
    }
    
    init(from decoder: Decoder) throws {
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        let id            = try container.decode(CLong.self, forKey: .id)
        let name          = try container.decode(String.self, forKey: .name)
        let prepMinutes   = try container.decode(Int.self, forKey: .prepMinutes)
        let imageFileName = try container.decode(String.self, forKey: .imageFileName)
        let servings      = try container.decode(Int.self, forKey: .servings)
        
        // If recipe object has ingredient and instruction data, decode it according to the
        // structs provided at the bottom of the file
        let ingredientsMetadata  = try? container.decode([IngredientsMetadata].self, forKey: .ingredients)
        let instructionsMetadata = try? container.decode([InstructionsMetadata].self, forKey: .instructions)
        
        // API ingredient text data is found under "originalString" key for each ingredient object
        // This is similar for instructions but it has nested arrays of objects
        let ingredients = ingredientsMetadata?.map { $0.originalString }
        let instructions = instructionsMetadata?.flatMap { $0.steps.map { $0.step } }
        
        self.init(
            id: id,
            name: name,
            prepMinutes: prepMinutes,
            image: imageFileName,
            ingredients: ingredients,
            instructions: instructions,
            servings: servings
        )
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
