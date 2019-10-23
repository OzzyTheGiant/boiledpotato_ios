import UIKit

class SearchResultsViewController : UIViewController {
    let layout = SearchResultsViewLayout()
    var searchKeywords : String = ""
    var cuisine : String = ""
    
    convenience init(_ keywords: String, cuisine: String) {
        self.init()
        self.searchKeywords = keywords
        self.cuisine = cuisine
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        layout.arrangeSubviews(parent: view)
        print("\(searchKeywords) \(cuisine)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
