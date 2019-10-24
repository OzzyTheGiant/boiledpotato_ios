import UIKit
import ToastSwiftFramework

class MainViewController: UIViewController {
    private let layout = MainViewLayout()
    private var selectedCuisineButton : UICuisineButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.arrangeSubviews(for: view)
        layout.backButton.addTarget(self, action: #selector(suspendApp), for: .touchUpInside)
        layout.searchButton.addTarget(self, action: #selector(startNextScene), for: .touchUpInside)
        
        // add click handlers for cuisine buttons
        for button in layout.cuisineButtons {
            button.addTarget(self, action: #selector(selectCuisineButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.setUpScrollViewContentSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
    
    /** Dismiss keyboard app when pressing outside of search field */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func suspendApp(_ sender: AnyObject) {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
    @objc func startNextScene(_ sender: AnyObject) {
        if let keywords = layout.searchField.text, !keywords.isEmpty {
            navigationController?.pushViewController(
                SearchResultsViewController(keywords, cuisine: selectedCuisineButton?.currentTitle?.lowercased() ?? ""),
                animated: true
            ); return
        }
        
        var style = ToastStyle()
        style.backgroundColor = .accent
        view.makeToast(NSLocalizedString("SEARCH_FIELD_EMPTY", comment: ""), duration: 3.0, position: .bottom, style: style)
    }
}

