import UIKit
import Stevia
import ShimmerSwift

class SearchResultsViewLayout {
    // loading indicators
    let placeholderComponent = UIStackView().style(component_placeholders)
    let placeholders = [ShimmeringView(), ShimmeringView()]
    let headerComponent = UIHeaderView(titleKey: "SEARCH_RESULTS_VIEW_TITLE")
    let errorComponent = UIErrorView(true)
    weak var recipeCollection : UICollectionView!
    
    func arrangeSubviews(parent: UIView) {
        let collectionLayout = UICollectionViewFlowLayout()
        let collectionWidth = parent.frame.width - Dimens.padding_viewport * 2
        
        // Flow Layout settings
        collectionLayout.minimumInteritemSpacing = Dimens.padding_viewport
        collectionLayout.minimumLineSpacing = Dimens.padding_viewport
        collectionLayout.sectionInset = .zero
        collectionLayout.footerReferenceSize = CGSize(width: collectionWidth, height: Dimens.button_load_more_height)
        collectionLayout.itemSize = CGSize(width: collectionWidth, height: Dimens.placeholder_height)
        
        let recipeCollection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        recipeCollection.bounces = false
        
        parent.sv(
            headerComponent,
            placeholderComponent,
            recipeCollection,
            errorComponent
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
        
        // recipe collection constraints
        let p = Dimens.padding_viewport
        recipeCollection.left(p).right(p).bottom(p)
        recipeCollection.Top == placeholderComponent.Top
        recipeCollection.Width == parent.Width
        recipeCollection.Bottom == parent.Bottom
        recipeCollection.alwaysBounceVertical = true
        recipeCollection.backgroundColor = .none

        // error component constraints
        errorComponent.Top == headerComponent.Bottom
        errorComponent.Width == parent.Width
        errorComponent.Bottom == parent.Bottom
        
        self.recipeCollection = recipeCollection
        
        // visibility
        recipeCollection.isHidden = true
        errorComponent.isHidden = true
    }
}
