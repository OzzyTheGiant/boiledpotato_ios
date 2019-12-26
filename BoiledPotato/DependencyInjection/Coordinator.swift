import UIKit
import Swinject

class Coordinator {
    unowned let navController : UINavigationController
    unowned let container : Container
    
    init(navController: UINavigationController, container: Container) {
        self.navController = navController
        self.container = container
    }
    
    func start() {
        let controller = MainViewController()
        controller.coordinator = self
        navController.setNavigationBarHidden(true, animated: false)
        navController.pushViewController(controller, animated: false)
    }
    
    func stop() {
        // suspend app into background
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
    func displaySearchResultsView(_ searchKeywords: String, cuisine: String) {
        let controller = container.resolve(SearchResultsViewController.self)!
        controller.viewModel.searchKeywords = searchKeywords
        controller.viewModel.cuisine = cuisine
        controller.coordinator = self
        navController.pushViewController(controller, animated: true)
    }
    
    func displayRecipeView(with recipe: Recipe) {
        let controller = container.resolve(RecipeViewController.self)!
        controller.viewModel.recipe = recipe
        controller.coordinator = self
        navController.pushViewController(controller, animated: true)
    }
    
    func returnToPreviousView() {
        navController.popViewController(animated: true)
    }
    
    /** Needed to remove a recipe from collection if a recipe is no longer a favorite */
    func returnToPreviousView(result: Recipe) {
        returnToPreviousView()
        (navController.viewControllers.last as! SearchResultsViewController).updateFavoritesList(with: result)
    }
}
