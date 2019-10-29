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
