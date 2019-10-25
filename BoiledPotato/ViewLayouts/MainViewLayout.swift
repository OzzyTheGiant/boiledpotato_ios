import Foundation
import UIKit
import Stevia

class MainViewLayout {
    let searchComponent  = UISearchView("MAIN_VIEW_TITLE")
    let scrollView       = UIScrollView()
    let filterComponent  = UICuisineFilterView(true)
    
    func arrangeSubviews(for parent: UIView) {
        parent.backgroundColor = .white
        
        parent.sv([
            searchComponent,
            scrollView.sv(filterComponent)
        ])
        
        // constraints
        searchComponent.Top == parent.layoutMarginsGuide.Top
        searchComponent.fillHorizontally()
        searchComponent.activateSubviewConstraints()
        searchComponent.constrainBottom()
        
        scrollView.Top == searchComponent.Bottom
        scrollView.Bottom == parent.Bottom
        scrollView.Width == filterComponent.Width
        
        filterComponent.Top == scrollView.Top
        filterComponent.Width == parent.Width
        filterComponent.activateSubviewConstraints()
        filterComponent.arrangeCuisineButtons(rootView: parent)
    }
    
    func setUpScrollViewContentSize(rootViewSize: CGSize) {
        scrollView.contentSize.height = filterComponent.frame.size.height
        scrollView.contentSize.width = rootViewSize.width
    }
}
