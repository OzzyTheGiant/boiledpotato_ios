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
        
        layout.recipeCollection.dataSource = self
        layout.recipeCollection.delegate = self
        layout.recipeCollection.register(UIRecipeCard.self, forCellWithReuseIdentifier: UIRecipeCard.id)
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
        return cell
    }
}

extension SearchResultsViewController : UICollectionViewDelegate {
    // TODO: implement click handlers for collection items
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
