import UIKit
import Stevia

class UICuisineButton : UIButton {
    private var isChecked = false
    
    convenience init (textKey: String, iconKey: String) {
        self.init()
        
        // content
        self.setTitle(NSLocalizedString(textKey, comment: ""), for: .normal)
        self.setImage(UIImage(named: iconKey), for: .normal)
        
        // core styles
        self.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.font_size_cuisine_button)
        self.layer.cornerRadius = Dimens.border_radius_cuisine
        self.height(Dimens.button_size_cuisine)
        
        // arrangement and toggling styles
        self.alignImageAndTitleVertically()
        self.toggle()
    }
    
    /** stack button icon above button text */
    private func alignImageAndTitleVertically(
        padding: CGFloat = Dimens.padding_button_cuisine,
        iconSize: CGFloat = Dimens.icon_size_cuisine,
        totalSize: CGFloat = Dimens.button_size_cuisine
    ){
        let titleSize = self.titleLabel!.frame.size
        
        // apparently, constraints do not work on UIButton titleLabels, so edge insets are needed
        self.titleEdgeInsets = UIEdgeInsets(
            top: iconSize + padding,
            left: -(totalSize - titleSize.width) / 3,
            bottom: 0,
            right: 0
        )
        
        self.imageView!.translatesAutoresizingMaskIntoConstraints = false
        self.imageView!.CenterX == self.CenterX
        self.imageView!.Top == self.Top + padding
        self.imageView!.size(iconSize)
    }
    
    /** change button styles based on whether it's checked or not */
    func toggle() {
        self.backgroundColor = isChecked ? .primary : .neutral
        self.imageView?.tintColor = isChecked ? .neutral : .primary
        self.setTitleColor(isChecked ? .neutral : .primary, for: UIControl.State.normal)
        isChecked = !isChecked
    }
}
