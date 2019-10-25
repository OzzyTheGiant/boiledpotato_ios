import UIKit
import Stevia
import ShimmerSwift

class SearchResultsViewLayout {
    // loading indicators
    let placeholderComponent = UIStackView().style(component_placeholders)
    let placeholders = [ShimmeringView(), ShimmeringView()]
    let headerComponent = UIHeaderView(titleKey: "SEARCH_RESULTS_VIEW_TITLE")
    
    func arrangeSubviews(parent: UIView) {
        parent.sv(
            headerComponent,
            placeholderComponent
        )
        
        // header component and subviews' constraints
        headerComponent.Top == parent.layoutMarginsGuide.Top
        headerComponent.Left == parent.Left
        headerComponent.Right == parent.Right
        headerComponent.activateSubviewConstraints()
        headerComponent.constrainBottom()
        
        // placeholder component constraints
        placeholderComponent.Top == headerComponent.Bottom + Dimens.padding_viewport
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
