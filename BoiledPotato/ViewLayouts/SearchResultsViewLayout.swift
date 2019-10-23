import UIKit
import Stevia
import ShimmerSwift

class SearchResultsViewLayout {
    let placeholderComponent = UIStackView().style(component_placeholders)
    let placeholders = [ShimmeringView(), ShimmeringView(), ShimmeringView()]
    
    func arrangeSubviews(parent: UIView) {
        parent.sv(placeholderComponent)
        
        placeholderComponent.Top == parent.layoutMarginsGuide.Top
        placeholderComponent.Left == parent.Left
        placeholderComponent.Right == parent.Right
        placeholderComponent.Bottom == parent.Bottom - Dimens.padding_viewport
        
        placeholders.forEach { placeholder in
            placeholderComponent.addArrangedSubview(placeholder)
            placeholder.Left == placeholderComponent.Left + Dimens.padding_viewport
            placeholder.Right == placeholderComponent.Right - Dimens.padding_viewport
            placeholder.contentView = UIView().style(placeholder(_:))
            placeholder.shimmerSpeed = 350
            placeholder.shimmerHighlightLength = 0.8
            placeholder.isShimmering = true
        }
    }
}
