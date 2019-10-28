import UIKit

class SearchResultsViewController : UIViewController {
    weak var coordinator : Coordinator?
    let layout = SearchResultsViewLayout()
    let viewModel : SearchResultsViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: SearchResultsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        layout.arrangeSubviews(parent: view)
        layout.headerComponent.backButton.addTarget(self, action: #selector(endScene), for: .touchUpInside)
    }
    
    @objc func endScene() {
        coordinator?.returnToMainView()
    }
}
