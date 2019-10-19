import UIKit

class MainViewController: UIViewController {
    private let layout = MainViewLayout()
    private var selectedCuisineButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.arrangeSubviews(for: view)
        
        // add click handlers for cuisine buttons
        for button in layout.cuisineButtons {
            button.addTarget(self, action: #selector(selectCuisineButton), for: .touchUpInside)
        }
    }
    
    @objc func selectCuisineButton(_ button: UIButton) {
        if button == selectedCuisineButton {
            layout.toggleCuisineButton(button, check: false);
            selectedCuisineButton = nil; return
        }
        
        if selectedCuisineButton != nil {
            layout.toggleCuisineButton(selectedCuisineButton!, check: false)
        }
        
        layout.toggleCuisineButton(button, check: true)
        selectedCuisineButton = button
    }
}

