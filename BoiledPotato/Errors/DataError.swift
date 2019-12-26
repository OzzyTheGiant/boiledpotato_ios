import Foundation

enum DataError : Error {
    case noResultsFound
}

extension DataError : LocalizedError {
    public var errorDescription: String? {
        get {
            switch(self) {
                case .noResultsFound: return NSLocalizedString("NO_DATA_ERROR", comment: "")
            }
        }
    }
}
