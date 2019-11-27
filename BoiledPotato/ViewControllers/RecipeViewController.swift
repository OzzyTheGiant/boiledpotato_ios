import UIKit

class RecipeViewController : UIViewController {
    weak var coordinator: Coordinator?
    let viewModel: RecipeViewModel
    let layout = RecipeViewLayout()
    let imageBaseUrl : String
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: RecipeViewModel, imageBaseUrl: String) {
        self.viewModel = viewModel
        self.imageBaseUrl = imageBaseUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        layout.setContent(recipe: viewModel.recipe, imageBaseUrl: imageBaseUrl)
        layout.arrangeSubviews(parent: view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.setUpScrollViewContentSize(rootViewSize: layout.scrollViewContent.frame.size)
    }
}
