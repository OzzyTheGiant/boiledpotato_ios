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
    
    init(id: CLong, name: String, prepMinutes: Int, image: String) {
        self.id = id
        self.name = name
        self.prepMinutes = prepMinutes
        self.imageFileName = image
    }
}

extension Recipe : Decodable {
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "title"
        case prepMinutes = "readyInMinutes"
        case imageFileName = "image"
    }
    
    init(from decoder: Decoder) throws {
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        let name          = try container.decode(String.self, forKey: .name)
        let prepMinutes   = try container.decode(Int.self, forKey: .prepMinutes)
        let imageFileName = try container.decode(String.self, forKey: .imageFileName)
        
        self.init(id: 0, name: name, prepMinutes: prepMinutes, image: imageFileName)
    }
}
