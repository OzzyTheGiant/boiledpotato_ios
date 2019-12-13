import UIKit

class RecipeViewController : UIViewController {
    weak var coordinator: Coordinator?
    @objc let viewModel: RecipeViewModel
    
    let layout = RecipeViewLayout()
    let imageBaseUrl : String
    
    var recipeQueryObserver : NSKeyValueObservation?
    
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
        layout.arrangeSubviews(for: view)
        
        layout.headerComponent.backButton.addTarget(self, action: #selector(endScene), for: .touchUpInside)
        layout.errorComponent.button.addTarget(viewModel, action: #selector(viewModel.fetchRecipeDetails), for: .touchUpInside)
    
        // define callback for recipe details query result data, to update UI
        recipeQueryObserver = observe(\.viewModel.queryObservable) { controller, _ in
            controller.process(resource: controller.viewModel.queryResult)
        }
        
        viewModel.fetchRecipeDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Check that recipe details exist and if so, adjust height of views.
        // This is necessary when rotating the screen
        if viewModel.recipe.ingredients != nil {
            layout.recipeIngredients.adjustHeightToContent()
            layout.recipeInstructions.adjustHeightToContent()
        }
        
        // CRITICAL - needs to be called to update positions of all views after screen rotation updates have been set
        layout.scrollViewContent.layoutIfNeeded()
        layout.setUpScrollViewContentSize(rootViewSize: view.frame.size)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    func process(resource: Resource<Recipe>) {
        switch(resource) {
            case is Resource<Recipe>.Success :
                toggleLoadingIndicators()
                displayRecipeDetails(resource.data!); break
            case is Resource<Recipe>.Error :
                toggleLoadingIndicators()
                toggleError(on: true, message: resource.message!); break
            default:
                toggleError()
                toggleLoadingIndicators(); break
        }
    }
    
    private func toggleLoadingIndicators() {
        layout.recipeIngredients.toggleShimmering()
        layout.recipeInstructions.toggleShimmering()
    }
    
    /** set additional recipe data from API resource stored in viewmodel */
    private func displayRecipeDetails(_ recipe: Recipe) {
        layout.recipeLabels.servingsLabel.text = "\(String(recipe.servings)) \(NSLocalizedString("SERVINGS", comment: ""))"
        layout.recipeLabels.prepTimeLabel.text = "\(String(recipe.prepMinutes)) \(NSLocalizedString("MINUTES", comment: ""))"
        
        // convert text arrays to a bulleted list string and set them on the UITextViews
        layout.recipeIngredients.set(details: "\u{2022} \(recipe.ingredients!.joined(separator: "\n\u{2022} "))")
        layout.recipeInstructions.set(details: "\u{2022} \(recipe.instructions!.joined(separator: "\n\u{2022} "))")
        
        // change scroll view content size according to new details' content size
        layout.scrollViewContent.layoutIfNeeded()
    }
    
    private func toggleError(on: Bool = false, message: String? = nil) {
        layout.errorComponent.isHidden = !on
        layout.errorComponent.message.text = message
    }
    
    @objc func endScene() {
        coordinator?.returnToPreviousView()
    }
}
