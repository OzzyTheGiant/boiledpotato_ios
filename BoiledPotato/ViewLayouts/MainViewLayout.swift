import Foundation
import UIKit

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
        parent.addSubview(searchComponent)
        parent.addSubview(filterComponent)
        
        // extension to add multiple views at once
        searchComponent.addSubviews([
            title,
            backButton,
            favoritesButton,
            searchField,
            searchButton
        ])
        
        // attach subtitle, paragraph, and all cuisine buttons
        filterComponent.addSubviews([cuisineHeading, cuisineParagraph] + cuisineButtons)
        
        // search component and subview constraints
        searchComponent.topAnchor.constraint(equalTo: parent.layoutMarginsGuide.topAnchor).isActive = true
        searchComponent.leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
        searchComponent.rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
        searchComponent.bottomAnchor.constraint(equalTo: searchField.bottomAnchor, constant: Dimens.padding_viewport).isActive = true
        
        backButton.topAnchor.constraint(equalTo: searchComponent.layoutMarginsGuide.topAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: searchComponent.layoutMarginsGuide.leftAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: Dimens.button_size_main).isActive = true
        backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor).isActive = true
        
        favoritesButton.topAnchor.constraint(equalTo: searchComponent.layoutMarginsGuide.topAnchor).isActive = true
        favoritesButton.rightAnchor.constraint(equalTo: searchComponent.layoutMarginsGuide.rightAnchor).isActive = true
        favoritesButton.widthAnchor.constraint(equalToConstant: Dimens.button_size_main).isActive = true
        favoritesButton.heightAnchor.constraint(equalTo: favoritesButton.widthAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: searchComponent.layoutMarginsGuide.topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: backButton.rightAnchor).isActive = true
        title.rightAnchor.constraint(equalTo: favoritesButton.leftAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: title.intrinsicContentSize.width).isActive = true
        title.heightAnchor.constraint(equalToConstant: Dimens.button_size_main).isActive = true
        
        searchField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Dimens.padding_viewport).isActive = true
        searchField.leftAnchor.constraint(equalTo: searchComponent.layoutMarginsGuide.leftAnchor).isActive = true
        searchField.rightAnchor.constraint(equalTo: searchButton.leftAnchor, constant: -Dimens.margin_main).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: Dimens.button_size_main).isActive = true
        
        searchButton.topAnchor.constraint(equalTo: searchField.topAnchor).isActive = true
        searchButton.rightAnchor.constraint(equalTo: searchComponent.layoutMarginsGuide.rightAnchor).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: searchComponent.layoutMarginsGuide.bottomAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: Dimens.button_size_main).isActive = true
        searchButton.heightAnchor.constraint(equalTo: searchButton.widthAnchor).isActive = true
        
        // filter component and subview constraints
        filterComponent.topAnchor.constraint(equalTo: searchComponent.bottomAnchor).isActive = true
        filterComponent.leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
        filterComponent.rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
        filterComponent.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        
        cuisineHeading.topAnchor.constraint(equalTo: filterComponent.layoutMarginsGuide.topAnchor).isActive = true
        cuisineHeading.leftAnchor.constraint(equalTo: filterComponent.layoutMarginsGuide.leftAnchor).isActive = true
        cuisineHeading.rightAnchor.constraint(equalTo: filterComponent.layoutMarginsGuide.rightAnchor).isActive = true
        
        cuisineParagraph.topAnchor.constraint(equalTo: cuisineHeading.bottomAnchor, constant: Dimens.padding_viewport).isActive = true
        cuisineParagraph.leftAnchor.constraint(equalTo: filterComponent.layoutMarginsGuide.leftAnchor).isActive = true
        cuisineParagraph.rightAnchor.constraint(equalTo: filterComponent.layoutMarginsGuide.rightAnchor).isActive = true
        
        for (index, button) in cuisineButtons.enumerated() {
            arrangeCuisineButton(button, index: index, parent: parent)
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
        
        cuisineButton.translatesAutoresizingMaskIntoConstraints = false
        cuisineButton.layer.cornerRadius = Dimens.border_radius_cuisine
        cuisineButton.heightAnchor.constraint(equalToConstant: Dimens.button_size_cuisine).isActive = true
        
        return cuisineButton
    }
    
    /** Lay out cuisine buttons as part of a 3 x 3 grid */
    private func arrangeCuisineButton(_ button: UIButton, index: Int, parent: UIView) {
        let containerSize = parent.frame.size
        // root view width - outer padding and columng gaps / number of columns / root view width to get percentage as decimal
        let multiplier = (containerSize.width - (Dimens.padding_viewport * 4)) / 3 / containerSize.width
        let topAnchor = index < 3 ? cuisineParagraph.bottomAnchor : cuisineButtons[index - 3].bottomAnchor
        
        // anchor to cuisine paragraph if it's one of first three buttons, otherwise use button above
        button.topAnchor.constraint(equalTo: topAnchor, constant: Dimens.padding_viewport).isActive = true
        button.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: multiplier).isActive = true
        
        switch((index + 1) % 3) {
            // attach to left, center, or right of parent component based on button order
            case 1: button.leftAnchor.constraint(equalTo: filterComponent.layoutMarginsGuide.leftAnchor).isActive = true; break
            case 2: button.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true; break
            default: button.rightAnchor.constraint(equalTo: filterComponent.layoutMarginsGuide.rightAnchor).isActive = true; break
        }
        
        button.alignImageAndTitleVertically()
    }
}
