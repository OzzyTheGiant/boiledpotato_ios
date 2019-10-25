import Stevia

class UISearchView : UIHeaderView {
    let favoritesButton = UIButton("ICO_Star").style(button_icon)
    let searchField     = UIPaddedTextField(hint: "SEARCH_FIELD_PLACEHOLDER")
    let searchButton    = UIButton("ICO_Search").style(button_icon_primary)
    
    convenience init(_ titleKey: String) {
        self.init(titleKey: titleKey)
        self.sv(favoritesButton, searchField, searchButton)
    }
    
    override func activateSubviewConstraints() {
        super.activateSubviewConstraints()
        favoritesButton.Top == self.layoutMarginsGuide.Top
        favoritesButton.Right == self.layoutMarginsGuide.Right
        
        searchField.Top == title.Bottom + Dimens.padding_viewport
        searchField.Left == self.layoutMarginsGuide.Left
        searchField.Right == searchButton.Left - Dimens.margin_main
        searchField.Bottom == searchButton.Bottom
        
        searchButton.Top == searchField.Top
        searchButton.Right == self.layoutMarginsGuide.Right
    }
    
    override func constrainBottom() {
        self.Bottom == searchButton.Bottom - Dimens.padding_viewport * 2
    }
}
