import Foundation

/** a generic class for specifying data loading states for any data source */
class Resource<T> {
    let data : T?
    let message: String?
    
    init(data: T? = nil, message: String? = nil) {
        self.data = data
        self.message = message
    }
    
    class Success : Resource<T> {
        init(_ data: T) { super.init(data: data) }
    }
    
    class Error : Resource<T> {
        init(_ message: String) { super.init(message: message) }
    }
    
    class Loading : Resource<T> {}
}
