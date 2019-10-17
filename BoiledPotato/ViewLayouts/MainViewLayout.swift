import Foundation
import UIKit
import Stevia

class MainViewLayout : ViewLayout {
    
    // searchComponent and its subviews
    lazy var searchComponent = createComponent(withColor: .neutral)
    lazy var backButton = createIconButton(withImageAsset: "ICO_Back_Arrow")
    lazy var title = createViewLayoutTitle(key: "MAIN_VIEW_TITLE")
    lazy var favoritesButton = createIconButton(withImageAsset: "ICO_Star")
    lazy var searchField = createField(placeholder: "SEARCH_FIELD_PLACEHOLDER")
    lazy var searchButton = createIconButton(withImageAsset: "ICO_Search", color: .primary)
    
    // filterComponent and its subviews
    lazy var filterComponent = createComponent()
    lazy var cuisineHeading = createTextHeading(key: "CUISINE_HEADING")
    lazy var cuisineParagraph = createText(key: "CUISINE_PARAGRAPH", alignment: NSTextAlignment.center)
    
    // Cuisine buttons
    var cuisineButtons : [UIButton] = [
        createCuisineButton("AMERICAN", iconKey: "ICO_Burger"),
        createCuisineButton("MEXICAN", iconKey: "ICO_Taco"),
        createCuisineButton("CHINESE", iconKey: "ICO_Rice"),
        createCuisineButton("JAPANESE", iconKey: "ICO_Sushi"),
        createCuisineButton("INDIAN", iconKey: "ICO_Curry"),
        createCuisineButton("FRENCH", iconKey: "ICO_Croissant"),
        createCuisineButton("ITALIAN", iconKey: "ICO_Pizza"),
        createCuisineButton("SPANISH", iconKey: "ICO_Paella"),
        createCuisineButton("BRITISH", iconKey: "ICO_Fish_And_Chips"),
    ]
    
    init(rootView parent: UIView) {
        super.init()
        parent.backgroundColor = .white
        
        // create UIView hierarchy with Stevia
        parent.sv([
            searchComponent.sv([
                title,
                backButton,
                favoritesButton,
                searchField,
                searchButton
            ]),
            filterComponent.sv([
                cuisineHeading,
                cuisineParagraph
            ] + cuisineButtons
            )
        ])
        
        // search component and subview constraints
        searchComponent.Top == parent.layoutMarginsGuide.Top
        searchComponent.Left == parent.Left
        searchComponent.Right == parent.Right
        searchComponent.Bottom == searchButton.Bottom - Dimens.padding_viewport * 2
          
        backButton.Top == searchComponent.layoutMarginsGuide.Top
        backButton.Left == searchComponent.layoutMarginsGuide.Left
        
        favoritesButton.Top == searchComponent.layoutMarginsGuide.Top
        favoritesButton.Right == searchComponent.layoutMarginsGuide.Right
            
        title.Top == searchComponent.layoutMarginsGuide.Top
        title.Left == backButton.Right
        title.Right == favoritesButton.Left
        title.Bottom == backButton.Bottom

        searchField.Top == title.Bottom + Dimens.padding_viewport
        searchField.Left == searchComponent.layoutMarginsGuide.Left
        searchField.Right == searchButton.Left - Dimens.margin_main
        searchField.Bottom == searchButton.Bottom
    
        searchButton.Top == searchField.Top
        searchButton.Right == searchComponent.layoutMarginsGuide.Right
        
        // filter component and subview constraints
        filterComponent.Top == searchComponent.Bottom
        filterComponent.Left == parent.Left
        filterComponent.Right == parent.Right
        filterComponent.Bottom == parent.Bottom
      
        cuisineHeading.Top == filterComponent.layoutMarginsGuide.Top
        cuisineHeading.Left == filterComponent.layoutMarginsGuide.Left
        cuisineHeading.Right == filterComponent.layoutMarginsGuide.Right
        
        cuisineParagraph.Top == cuisineHeading.Bottom + Dimens.padding_viewport
        cuisineParagraph.Left == filterComponent.layoutMarginsGuide.Left
        cuisineParagraph.Right == filterComponent.layoutMarginsGuide.Right
        
        for (index, button) in cuisineButtons.enumerated() {
            arrangeCuisineButton(button, index: index, rootView: parent)
        }
    }
    
    private class func createCuisineButton(_ textKey: String, iconKey: String) -> UIButton {
        let cuisineButton = UIButton()
        let image = UIImage(named: iconKey)
        
        cuisineButton.backgroundColor = .neutral
        cuisineButton.setImage(image, for: UIControl.State.normal)
        cuisineButton.imageView?.tintColor = .primary
        
        cuisineButton.setTitle(NSLocalizedString(textKey, comment: ""), for: UIControl.State.normal)
        cuisineButton.setTitleColor(.primary, for: UIControl.State.normal)
        cuisineButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.font_size_cuisine_button)
        
//        cuisineButton.translatesAutoresizingMaskIntoConstraints = false
        cuisineButton.layer.cornerRadius = Dimens.border_radius_cuisine
        cuisineButton.height(Dimens.button_size_cuisine)
        
        return cuisineButton
    }
    
    /** Lay out cuisine buttons as part of a 3 x 3 grid */
    private func arrangeCuisineButton(_ button: UIButton, index: Int, rootView: UIView) {
        let containerSize = rootView.frame.size
        // root view width - outer padding and columng gaps / number of columns / root view width * 100 to get percentage
        let columnSize = (containerSize.width - (Dimens.padding_viewport * 4)) / 3 / containerSize.width * 100
        let topAnchor = index < 3 ? cuisineParagraph.Bottom : cuisineButtons[index - 3].Bottom
        
        // anchor to cuisine paragraph if it's one of first three buttons, otherwise use button above it
        button.Top == topAnchor + Dimens.padding_viewport
        button.Width == columnSize % rootView.Width

        switch((index + 1) % 3) {
            // attach to left, center, or right of parent component based on button order
            case 1: button.Left == filterComponent.layoutMarginsGuide.Left; break
            case 2: button.CenterX == filterComponent.CenterX; break
            default: button.Right == filterComponent.layoutMarginsGuide.Right
        }
        
        button.alignImageAndTitleVertically()
    }
}
