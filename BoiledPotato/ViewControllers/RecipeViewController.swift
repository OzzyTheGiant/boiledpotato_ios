import UIKit

class RecipeViewController : UIViewController {
    weak var coordinator: Coordinator?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(recipe: Recipe) {
        super.init(nibName: nil, bundle: nil)
        print(recipe)
    }
}
