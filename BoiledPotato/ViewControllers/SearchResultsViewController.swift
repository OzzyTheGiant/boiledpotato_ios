import UIKit
import Kingfisher

class SearchResultsViewController : UIViewController {
    // dependencies
    weak var coordinator : Coordinator?
    @objc let viewModel : SearchResultsViewModel
    
    let imageBaseUrl : String
    let layout = SearchResultsViewLayout()
    
    var searchQueryObserver : NSKeyValueObservation?
    var footerIndexPath : IndexPath?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: SearchResultsViewModel, imageBaseUrl: String) {
        self.viewModel = viewModel
        self.imageBaseUrl = imageBaseUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        layout.arrangeSubviews(parent: view)
        layout.headerComponent.backButton.addTarget(self, action: #selector(endScene), for: .touchUpInside)
        
        // set up recipe collection views, datasource, and delegate
        layout.recipeCollection.dataSource = self
        layout.recipeCollection.delegate = self
        layout.recipeCollection.register(UIRecipeCard.self, forCellWithReuseIdentifier: UIRecipeCard.id)
        layout.recipeCollection.register(UIRecipeCollectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UIRecipeCollectionFooter.id)
        
        // add click handler on Retry Button
        layout.errorComponent.button.addTarget(self, action: #selector(onClickLoadButton), for: .touchUpInside)
        
        // define callback for search query result data, to update UI
        searchQueryObserver = observe(\.viewModel.queryObservable) { controller, _ in
            controller.process(resource: controller.viewModel.queryResult)
        }
        
        viewModel.fetchRecipes()
    }
    
    /** performs an action based on the status of resource provided */
    func process(resource: Resource<RecipeSearchQuery>) {
        switch(resource) {
            case is Resource<RecipeSearchQuery>.Success :
                toggleLoadingIndicators()
                displaySearchResults(); break
            case is Resource<RecipeSearchQuery>.Error :
                toggleLoadingIndicators()
                toggleError(on: true, message: resource.message!); break
            default:
                toggleError()
                toggleLoadingIndicators(); break
        }
    }
    
    func toggleLoadingIndicators() {
        if case 1...viewModel.maxResultsSize = viewModel.recipes.count {
            // toggle shimmer views on/off on first successful query
            layout.placeholders.forEach { placeholder in
                placeholder.isShimmering = false
            }
            
            layout.placeholderComponent.isHidden = true
        }
        
        if viewModel.recipes.count != 0 {
            // hereafter, use button as loading indicator instead of shimmer views
            changeLoadMoreButtonStatus(isLoading: true)
        }
    }
    
    func toggleError(on: Bool = false, message: String? = nil) {
        layout.recipeCollection.isScrollEnabled = on
        
        if viewModel.recipes.count == 0 {
            // display error in it's own component
            layout.errorComponent.message.text = message
            layout.errorComponent.isHidden = !on
        } else if let message = message {
            changeLoadMoreButtonStatus(isLoading: !on, errorMessage: message)
        }
    }
    
    func displaySearchResults() {
        let total = viewModel.recipes.count
        let resultCount = viewModel.queryResult.data!.recipes!.count
        let indexPaths = Array(total - resultCount...total - 1).map {
            IndexPath(item: $0, section: 0)
        }
        
        view.backgroundColor = .primary_background
        
        // set data for recipe collection
        layout.recipeCollection.insertItems(at: indexPaths)
        
        // make sure recipe collection is displayed and scrollable
        layout.recipeCollection.isHidden = false
        layout.recipeCollection.isScrollEnabled = true
        
        // reset Load More button
        changeLoadMoreButtonStatus(isLoading: false)
    }
    
    func changeLoadMoreButtonStatus(isLoading: Bool, errorMessage: String? = nil) {
        let footer = layout.recipeCollection
            .supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: footerIndexPath!)
            as! UIRecipeCollectionFooter
        
        if isLoading {
            footer.setLoadingStatus()
        } else if let error = errorMessage {
            footer.setErrorStatus(message: error)
        } else {
            footer.setSuccessStatus()
        }
        
        footer.setNeedsDisplay()
    }
    
    @objc func onClickLoadButton() {
        layout.recipeCollection.isScrollEnabled = false
        viewModel.fetchRecipes()
    }
    
    @objc func endScene() {
        coordinator?.returnToPreviousView()
    }
}

extension SearchResultsViewController : UICollectionViewDataSource {
    /** get number of items in collection */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    /** bind data to reusable view */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIRecipeCard.id, for: indexPath) as! UIRecipeCard
        cell.setText(viewModel.recipes[indexPath.item].name)
        cell.setImage(withFileName: imageBaseUrl + viewModel.recipes[indexPath.item].imageFileName)
        return cell
    }
    
    /** add Load More button at the bottom of collection view */
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UIRecipeCollectionFooter.id, for: indexPath)
            as! UIRecipeCollectionFooter
        
        // hide button if all results have been fetched from repository
        if (viewModel.totalResults > 0  && viewModel.totalResults == viewModel.recipes.count) {
            view.isHidden = true
        }
        
        // add click handler on first render
        if view.loadButton.actions(forTarget: self, forControlEvent: .touchUpInside) == nil {
            view.loadButton.addTarget(self, action: #selector(onClickLoadButton), for: .touchUpInside)
        }
        
        footerIndexPath = indexPath
        return view
    }
    
    /** Cancel the unfinished downloading task when the cell disappearing **/
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! UIRecipeCard).recipeImageView.kf.cancelDownloadTask()
    }
}

extension SearchResultsViewController : UICollectionViewDelegate {
    /** Start new Recipe view controller to display details */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.displayRecipeView(with: viewModel.recipes[indexPath.item])
    }
}
