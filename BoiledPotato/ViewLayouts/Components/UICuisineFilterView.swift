import Stevia

class UICuisineFilterView : UIView {
    let heading   = UILabel("CUISINE_HEADING").style(text_heading)
    let paragraph = UILabel("CUISINE_PARAGRAPH").style(description(_:))
    
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
    
    convenience init(_ custom: Bool) {
        self.init()
        self.style(component)
        self.sv([heading, paragraph] + cuisineButtons)
    }
    
    func activateSubviewConstraints() {
        heading.Top == self.layoutMarginsGuide.Top
        heading.Left == self.layoutMarginsGuide.Left
        heading.Right == self.layoutMarginsGuide.Right
        
        paragraph.Top == heading.Bottom + Dimens.padding_viewport
        paragraph.Left == self.layoutMarginsGuide.Left
        paragraph.Right == self.layoutMarginsGuide.Right
        
        self.Bottom == cuisineButtons.last!.Bottom - Dimens.padding_viewport
    }
    
    /** Lay out cuisine buttons as part of a 3 x 3 grid */
    func arrangeCuisineButtons(rootView: UIView) {
        for (index, button) in cuisineButtons.enumerated() {
            // root view width - outer padding and columng gaps / number of columns / root view width * 100 to get percentage
            let topAnchor = index < 3 ? paragraph.Bottom : cuisineButtons[index - 3].Bottom
            
            // anchor to cuisine paragraph if it's one of first three buttons, otherwise use button above it
            button.Top == topAnchor + Dimens.padding_viewport
            button.Width == 30 % rootView.Width

            switch((index + 1) % 3) {
                // attach to left, center, or right of parent component based on button order
                case 1: button.Left == self.layoutMarginsGuide.Left; break
                case 2: button.CenterX == self.CenterX; break
                default: button.Right == self.layoutMarginsGuide.Right
            }
        }
    }
}
