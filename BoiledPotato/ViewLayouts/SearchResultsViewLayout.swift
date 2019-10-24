import UIKit
import Stevia
import ShimmerSwift

class SearchResultsViewLayout {
    // loading indicators
    let placeholderComponent = UIStackView().style(component_placeholders)
    let placeholders = [ShimmeringView(), ShimmeringView()]
    
    // header component
    let headerComponent = UIView().style(component_bkg_neutral)
    let backButton = UIButton("ICO_Back_Arrow").style(button_icon)
    let title = UILabel("SEARCH_RESULTS_VIEW_TITLE").style(text_heading_view_layout)
    
    func arrangeSubviews(parent: UIView) {
        parent.sv(
            headerComponent.sv(backButton, title),
            placeholderComponent
        )
        
        // header component and subviews' constraints
        headerComponent.Top == parent.layoutMarginsGuide.Top
        headerComponent.Left == parent.Left
        headerComponent.Right == parent.Right
        headerComponent.Bottom == backButton.Bottom - Dimens.padding_viewport
        
        backButton.Top == headerComponent.layoutMarginsGuide.Top
        backButton.Left == headerComponent.layoutMarginsGuide.Left
        
        title.Top == headerComponent.layoutMarginsGuide.Top
        title.CenterX == headerComponent.CenterX
        title.Bottom == backButton.Bottom
        
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
