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
        
        layout.backButton.addTarget(self, action: #selector(endScene), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func endScene() {
        navigationController?.popViewController(animated: true)
    }
}
