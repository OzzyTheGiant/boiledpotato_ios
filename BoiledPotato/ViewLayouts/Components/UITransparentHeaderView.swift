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
        
        favoriteButton.Top == self.layoutMarginsGuide.Top
        favoriteButton.Right == self.layoutMarginsGuide.Right
    }
}
