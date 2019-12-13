import UIKit
import Stevia

class UITransparentHeaderView : UIHeaderView {
    let favoriteButton = UIButton("ICO_Star_Outline").style(button_icon)
    
    convenience init(_ custom: Bool) {
        self.init(titleKey: nil)
        self.sv(favoriteButton)
    }
    
    override func activateSubviewConstraints() {
        super.activateSubviewConstraints()
        
        let backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        
        favoriteButton.backgroundColor = backgroundColor
        backButton.backgroundColor = backgroundColor
        
        favoriteButton.Top == self.layoutMarginsGuide.Top
        favoriteButton.Right == self.layoutMarginsGuide.Right
    }
}
