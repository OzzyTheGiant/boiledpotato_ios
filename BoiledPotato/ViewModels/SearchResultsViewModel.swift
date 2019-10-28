class SearchResultsViewModel {
    let repository: Any? = nil
    let maxResultsSize = 10
    
    var searchKeywords : String = ""
    var cuisine : String = ""
    var recipes : [Recipe] = []
    
    init() {}
}
