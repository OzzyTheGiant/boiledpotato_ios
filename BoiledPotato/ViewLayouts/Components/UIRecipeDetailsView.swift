import UIKit
import Stevia
import ShimmerSwift

class UIRecipeDetailsView : UIView {
    let title = UILabel()
    let details = UILabel()
    let placeholderComponent = UIStackView().style(component_placeholders)
    let placeholders = [ShimmeringView(), ShimmeringView(), ShimmeringView()]
    
    convenience init(titleKey: String, color: UIColor = .primary) {
        self.init()
        
        // styles
        self.style(component)
        self.backgroundColor = color
        title.font = UIFont.boldSystemFont(ofSize: Dimens.font_size_headings)
        title.textColor = .accent
        
        self.sv(title, details, placeholderComponent)
        
        // constraints
        title.Top == self.layoutMarginsGuide.Top
        title.Left == self.layoutMarginsGuide.Left
        title.Right == self.layoutMarginsGuide.Right
        
        details.Top == title.Bottom + Dimens.padding_viewport
        details.Left == title.Left
        details.Right == title.Right
        details.Bottom >= title.Bottom + Dimens.padding_viewport + 120
        
        placeholderComponent.Top == details.Top
        placeholderComponent.Left == self.layoutMarginsGuide.Left
        placeholderComponent.Right == self.layoutMarginsGuide.Right
        placeholderComponent.Bottom == details.Bottom - Dimens.padding_viewport
        
        self.Bottom == details.Bottom
        
        // content
        title.text = NSLocalizedString(titleKey, comment: "")
    }
    
    /** add ShimmeringViews to UIStackView. Call this after stack view and its superview constraints are set up */
    func arrangeShimmerViews() {
        placeholders.forEach { placeholder in
            placeholderComponent.addArrangedSubview(placeholder)
            placeholder.Left == placeholderComponent.Left
            placeholder.Right == placeholderComponent.Right
            placeholder.contentView = UIView().style(placeholder_neutral)
            placeholder.shimmerSpeed = 420
            placeholder.shimmerHighlightLength = 0.5
            placeholder.isShimmering = true
        }
    }
    
    func toggleShimmering() {
        placeholders.forEach { placeholder in
            placeholder.isShimmering = !placeholder.isHidden
            placeholder.isHidden = !placeholder.isShimmering
        }
    }
}
