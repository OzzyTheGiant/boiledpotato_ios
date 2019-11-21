import UIKit

class RecipeViewController : UIViewController {
    weak var coordinator: Coordinator?
    let viewModel: RecipeViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: RecipeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
}
