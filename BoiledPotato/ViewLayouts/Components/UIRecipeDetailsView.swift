import UIKit
import Stevia
import ShimmerSwift

class UIRecipeDetailsView : UIView {
    let title = UILabel()
    let details = UITextView()
    let placeholderComponent = UIStackView().style(component_placeholders)
    let placeholders = [ShimmeringView(), ShimmeringView(), ShimmeringView()]
    
    convenience init(titleKey: String, color: UIColor = .primary) {
        self.init()
        
        // styles
        self.style(component)
        self.backgroundColor = color
        
        title.font = UIFont.boldSystemFont(ofSize: Dimens.font_size_headings)
        title.textColor = .accent
        
        details.backgroundColor = color
        details.isEditable = false
        details.isScrollEnabled = false
        
        self.sv(title, details, placeholderComponent)
        
        // constraints
        title.Top == self.layoutMarginsGuide.Top
        title.Left == self.layoutMarginsGuide.Left
        title.Right == self.layoutMarginsGuide.Right
        
        details.Top == title.Bottom + Dimens.padding_viewport
        details.Left == title.Left
        details.Right == title.Right
        details.Bottom == title.Bottom + Dimens.padding_viewport + 120
        
        placeholderComponent.Top == details.Top
        placeholderComponent.Left == self.layoutMarginsGuide.Left
        placeholderComponent.Right == self.layoutMarginsGuide.Right
        placeholderComponent.Bottom == details.Bottom - Dimens.padding_viewport
        
        self.Bottom == details.Bottom - Dimens.padding_viewport
        
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
            placeholder.isShimmering = !placeholder.isShimmering
        }
        
        placeholderComponent.isHidden = !placeholderComponent.isHidden
    }
    
    func set(details text: String) {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        // set line spacing and indents for bullet list
        paragraphStyle.lineHeightMultiple = 24.0
        paragraphStyle.maximumLineHeight = 24.0
        paragraphStyle.minimumLineHeight = 24.0
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 10
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: Dimens.font_size_main),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        details.attributedText = NSAttributedString(string: text, attributes: attributes)

        adjustHeightToContent()
    }
    
    func adjustHeightToContent() {
        // change height to match bullet list size, since it's constrained to placeholder component height
        details.bottomConstraint?.constant = details.intrinsicContentSize.height + Dimens.padding_viewport
    }
}
