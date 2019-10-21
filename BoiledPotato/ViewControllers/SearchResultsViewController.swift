import UIKit

class SearchResultsViewController : UIViewController {
    var searchKeywords : String = ""
    var cuisine : String = ""
    
    convenience init(_ keywords: String, cuisine: String) {
        self.init()
        self.searchKeywords = keywords
        self.cuisine = cuisine
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .primary_background
        print("\(searchKeywords) \(cuisine)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
