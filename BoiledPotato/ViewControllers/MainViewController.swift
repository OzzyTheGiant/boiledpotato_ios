import UIKit
import ToastSwiftFramework

class MainViewController: UIViewController {
    public weak var coordinator: Coordinator?
    private let layout = MainViewLayout()
    private var selectedCuisineButton : UICuisineButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.arrangeSubviews(for: view)
        
        // add click handlers for header buttons
        layout.searchComponent.backButton.addTarget(self, action: #selector(suspendApp), for: .touchUpInside)
        layout.searchComponent.searchButton.addTarget(self, action: #selector(validateAndSubmitSearchKeywords), for: .touchUpInside)
        layout.searchComponent.favoritesButton.addTarget(self, action: #selector(displayFavoriteRecipes), for: .touchUpInside)
        
        // add click handlers for cuisine buttons
        for button in layout.filterComponent.cuisineButtons {
            button.addTarget(self, action: #selector(selectCuisineButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.setUpScrollViewContentSize(rootViewSize: view.frame.size)
    }
    
    /** Dismiss keyboard app when pressing outside of search field */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /** toggle cuisine button colors to mark as selected or deselected */
    @objc func selectCuisineButton(_ button: UICuisineButton) {
        if button == selectedCuisineButton {
            button.toggle()
            selectedCuisineButton = nil; return
        }
        
        if selectedCuisineButton != nil { selectedCuisineButton?.toggle() }
        button.toggle()
        selectedCuisineButton = button
    }
    
    /** Called when Favorites button is clicked */
    @objc func displayFavoriteRecipes() {
        coordinator?.displaySearchResultsView("favorites", cuisine: "")
    }
    
    /** Called when Search button is clicked */
    @objc func validateAndSubmitSearchKeywords(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        if let keywords = layout.searchComponent.searchField.text, !keywords.isEmpty {
            let cuisine = selectedCuisineButton?.currentTitle?.lowercased() ?? ""
            let fixedKeywords = keywords.trimmingCharacters(in: .whitespaces).lowercased()
            
            coordinator?.displaySearchResultsView(fixedKeywords, cuisine: cuisine); return
        }
        
        var style = ToastStyle()
        style.backgroundColor = .accent
        view.makeToast(NSLocalizedString("SEARCH_FIELD_EMPTY", comment: ""), duration: 3.0, position: .bottom, style: style)
    }
    
    @objc func suspendApp(_ sender: AnyObject) {
        coordinator?.stop()
    }
}

