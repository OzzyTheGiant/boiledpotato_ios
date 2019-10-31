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
        
        collectionLayout.minimumInteritemSpacing = Dimens.padding_viewport
        collectionLayout.minimumLineSpacing = Dimens.padding_viewport
        collectionLayout.sectionInset = .zero
        collectionLayout.itemSize = CGSize(
            width: parent.frame.width - Dimens.padding_viewport * 2,
            height: Dimens.placeholder_height
        )
        
        let recipeCollection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        
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
        
        placeholderComponent.isHidden = true
        
        // recipe collection constraints
        let p = Dimens.padding_viewport
        recipeCollection.left(p).right(p).bottom(p)
        recipeCollection.Top == placeholderComponent.Top
        recipeCollection.Width == parent.Width
        recipeCollection.Bottom == parent.Bottom
        recipeCollection.alwaysBounceVertical = true
        recipeCollection.backgroundColor = .white
        
        self.recipeCollection = recipeCollection
        
        recipeCollection.isHidden = true
        
        errorComponent.Top == headerComponent.Bottom
        errorComponent.Width == parent.Width
        errorComponent.Bottom == parent.Bottom
    }
}
