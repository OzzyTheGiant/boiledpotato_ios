import Foundation

enum DataError : Error {
    case noResultsFound
    
    var localizedDescription: String {
        get {
            switch(self) {
                case .noResultsFound: return NSLocalizedString("NO_DATA_ERROR", comment: "")
            }
        }
    }
}
