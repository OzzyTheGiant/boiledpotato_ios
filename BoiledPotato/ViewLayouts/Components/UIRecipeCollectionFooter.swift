import UIKit
import Stevia

class UIRecipeCollectionFooter : UICollectionReusableView {
    static let id = "LoadButton"
    let loadButton = UIButton().style(button_text_primary)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sv(loadButton)
        
        loadButton.Top == self.Top + Dimens.padding_viewport
        loadButton.Width == self.Width
        loadButton.Bottom == self.Bottom
        
        loadButton.textKey("BUTTON_LOAD_MORE")
        loadButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Dimens.font_size_headings)
    }
}
