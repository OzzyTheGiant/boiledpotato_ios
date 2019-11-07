import UIKit

class SearchResultsViewController : UIViewController {
    weak var coordinator : Coordinator?
    let imageBaseUrl = "https://spoonacular.com/recipeImages/"
    let layout = SearchResultsViewLayout()
    var searchQueryObserver : NSKeyValueObservation?
    @objc let viewModel : SearchResultsViewModel
    
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
        
        layout.recipeCollection.dataSource = self
        layout.recipeCollection.delegate = self
        layout.recipeCollection.register(UIRecipeCard.self, forCellWithReuseIdentifier: UIRecipeCard.id)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // define callback for search query result data, to update UI
        searchQueryObserver = observe(\.viewModel.queryObservable) { controller, _ in
            controller.process(resource: controller.viewModel.queryResult)
        }
        
        viewModel.fetchRecipes()
    }
    
    func process(resource: Resource<RecipeSearchQuery>) {
        switch(resource) {
            case is Resource<RecipeSearchQuery>.Loading :
                toggleLoadingIndicators(); break;
            case is Resource<RecipeSearchQuery>.Success :
                toggleLoadingIndicators()
                displaySearchResults(); break;
            case is Resource<RecipeSearchQuery>.Error :
                toggleLoadingIndicators()
                toggleError(message: resource.message!); break;
            default: break;
        }
    }
    
    func toggleLoadingIndicators() {
        layout.placeholders.forEach { placeholder in
            placeholder.isShimmering = false
        }
        
        layout.placeholderComponent.isHidden = !layout.placeholderComponent.isHidden
    }
    
    func toggleError(message: String) {
        layout.errorComponent.message.text = message
        layout.errorComponent.isHidden = false
    }
    
    func displaySearchResults() {
        let count = viewModel.recipes.count
        let indexPaths = Array(count - viewModel.maxResultsSize...count - 1).map {
            IndexPath(item: $0, section: 0)
        }
        
        view.backgroundColor = .primary_background
        layout.recipeCollection.backgroundColor = .primary_background
        layout.recipeCollection.insertItems(at: indexPaths)
        layout.recipeCollection.isHidden = false
    }
    
    @objc func endScene() {
        coordinator?.returnToMainView()
    }
}

extension SearchResultsViewController : UICollectionViewDataSource {
    /** get number of items in collection */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    /** bind data to reusable view */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = layout.recipeCollection.dequeueReusableCell(withReuseIdentifier: UIRecipeCard.id, for: indexPath) as! UIRecipeCard
        cell.setText(viewModel.recipes[indexPath.item].name)
        cell.setImage(withFileName: imageBaseUrl + viewModel.recipes[indexPath.item].imageFileName) { _ in
            self.layout.recipeCollection.reloadItems(at: [indexPath])
        }
        return cell
    }
}

extension SearchResultsViewController : UICollectionViewDelegate {
    // TODO: implement click handlers for collection items
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
