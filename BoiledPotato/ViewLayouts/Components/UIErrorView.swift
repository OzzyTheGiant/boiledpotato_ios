import UIKit
import Stevia

class UIErrorView : UIView {
    let icon = UIImageView()
    let message = UILabel().style(description(_:))
    let button = UIButton().style(button_text_primary)
    
    convenience init(_ custom: Bool) {
        self.init()
        self.style(component)
        self.sv(icon, message, button)
        
        // set the icon image
        icon.image = UIImage(named: "ICO_Error")?
            .resized(to: CGSize(width: Dimens.icon_size_error, height: Dimens.icon_size_error))
            .withRenderingMode(.alwaysTemplate) // set this because a new image object was produced
        
        message.textKey("PLACEHOLDER_TEXT")
        button.textKey("BUTTON_RETRY")
        
        // coloring
        self.backgroundColor = .white
        icon.tintColor = .red
        
        // constraints
        message.Width == self.Width
        message.preferredMaxLayoutWidth = Dimens.max_text_width
        message.Left == self.Left + Dimens.padding_viewport
        message.Right == self.Right - Dimens.padding_viewport
        message.CenterX == self.CenterX
        message.CenterY == self.CenterY
        
        icon.size(Dimens.icon_size_error)
        icon.Bottom == message.Top - Dimens.margin_error_message
        icon.CenterX == self.CenterX
        
        button.Top == message.Bottom + Dimens.margin_error_message
        button.CenterX == self.CenterX
        button.width(Dimens.button_size_retry).height(
            button.intrinsicContentSize.height +
            Dimens.padding_main * 2
        )
        
        // fonts
        message.font = UIFont.systemFont(ofSize: Dimens.font_size_error_message)
        message.numberOfLines = 3
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Dimens.font_size_headings)
    }
}
