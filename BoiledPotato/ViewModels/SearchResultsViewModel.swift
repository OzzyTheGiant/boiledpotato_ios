class SearchResultsViewModel {
    let repository: Any? = nil
    let maxResultsSize = 10
    
    var searchKeywords : String = ""
    var cuisine : String = ""
    var recipes : [Recipe] = Array(repeating: Recipe(id: 0, name: "Sample Recipe", prepMinutes: 60, image: "sample.jpg"), count: 10)
    
    init() {}
    
    func fetchRecipes() -> [Recipe] {
        return recipes
    }
}
