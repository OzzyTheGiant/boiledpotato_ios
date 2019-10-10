import Foundation
import UIKit

class MainViewLayout : ViewLayout {
    lazy var searchComponent = createComponent()
    lazy var backButton = createIconButton(withImageAsset: "ICO_Back_Arrow")
    lazy var title = createViewLayoutTitle(key: "MAIN_VIEW_TITLE")
    lazy var favoritesButton = createIconButton(withImageAsset: "ICO_Star")
    lazy var searchField = createField(placeholder: "SEARCH_FIELD_PLACEHOLDER")
    lazy var searchButton = createIconButton(withImageAsset: "ICO_Search", color: .primary)
    
    init(rootView parent: UIView) {
        super.init()
        parent.backgroundColor = .white
        parent.addSubview(searchComponent)
        
        searchComponent.addSubviews(views: [
            title,
            backButton,
            favoritesButton,
            searchField,
            searchButton,
            filterComponent,
            cuisineHeading
        ])
        
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
        
        
    }
}
