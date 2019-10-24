import Foundation
import UIKit
import Stevia

class MainViewLayout {
    // searchComponent and its subviews
    let searchComponent   = UIView()            .style(component_background_neutral)
    let backButton        = UIButton()          .style(button_icon_back)
    let title             = UILabel()           .style(text_heading_vl_main)
    let favoritesButton   = UIButton()          .style(button_icon_star)
    let searchField       = UIPaddedTextField() .style(field_search)
    let searchButton      = UIButton()          .style(button_icon_search)
    
    // filterComponent and its subviews
    let scrollView        = UIScrollView()
    let filterComponent   = UIView()            .style(component)
    let cuisineHeading    = UILabel()           .style(text_heading_cuisine)
    let cuisineParagraph  = UILabel()           .style(text_paragraph_cuisine)
    
    // Cuisine buttons
    let cuisineButtons : [UICuisineButton] = [
        UICuisineButton(textKey: "AMERICAN", iconKey: "ICO_Burger"),
        UICuisineButton(textKey: "MEXICAN", iconKey: "ICO_Taco"),
        UICuisineButton(textKey: "CHINESE", iconKey: "ICO_Rice"),
        UICuisineButton(textKey: "JAPANESE", iconKey: "ICO_Sushi"),
        UICuisineButton(textKey: "INDIAN", iconKey: "ICO_Curry"),
        UICuisineButton(textKey: "FRENCH", iconKey: "ICO_Croissant"),
        UICuisineButton(textKey: "ITALIAN", iconKey: "ICO_Pizza"),
        UICuisineButton(textKey: "SPANISH", iconKey: "ICO_Paella"),
        UICuisineButton(textKey: "BRITISH", iconKey: "ICO_Fish_And_Chips"),
    ]
    
    func arrangeSubviews(for parent: UIView) {
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
            scrollView.sv(
                filterComponent.sv([
                    cuisineHeading,
                    cuisineParagraph
                ] + cuisineButtons
                )
            )
        ])
        
        // search component and subview constraints
        searchComponent.Top == parent.layoutMarginsGuide.Top
        searchComponent.Bottom == searchButton.Bottom - Dimens.padding_viewport * 2
        searchComponent.fillHorizontally()
          
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
        
        // scrollview, filter component and subview constraints
        scrollView.Top == searchComponent.Bottom
        scrollView.Bottom == parent.Bottom
        scrollView.Width == parent.Width
        
        filterComponent.Top == scrollView.Bottom
        filterComponent.Width == parent.Width
        filterComponent.Bottom == cuisineButtons.last!.Bottom - Dimens.padding_viewport
      
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
    }
    
    func setUpScrollViewContentSize() {
        scrollView.contentSize = filterComponent.frame.size
    }
}
