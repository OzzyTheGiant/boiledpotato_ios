import Stevia

class UIHeaderView : UIView {
    let backButton = UIButton("ICO_Back_Arrow").style(button_icon)
    let title      = UILabel().style(text_heading_view_layout)
    
    convenience init(titleKey: String?) {
        self.init()
        self.style(component)
        self.sv(backButton, title)
        
        if titleKey != nil {
            title.text = NSLocalizedString(titleKey!, comment: "")
            self.backgroundColor = .neutral
        }
    }
    
    func activateSubviewConstraints() {
        backButton.Top == self.layoutMarginsGuide.Top
        backButton.Left == self.layoutMarginsGuide.Left
        
        title.Top == self.layoutMarginsGuide.Top
        title.CenterX == self.CenterX
        title.Bottom == backButton.Bottom
    }
    
    func constrainBottom() {
        self.Bottom == backButton.Bottom - Dimens.padding_viewport
    }
}
