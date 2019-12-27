import UIKit
import Stevia

class UIRecipeCollectionFooter : UICollectionReusableView {
    static let id = "LoadButton"
    
    public let loadButton = UIButton().style(button_text_primary)
    public let loadingIndicator = UIActivityIndicatorView()
    private let errorIcon = UIImage(named:"ICO_Error")
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sv(loadButton, loadingIndicator)
        
        // constraints
        loadButton.Top == self.Top + Dimens.padding_viewport
        loadButton.Bottom == self.Bottom
        loadButton.Width <= Dimens.max_button_width
        loadButton.Width == self.Width
        loadButton.CenterX == self.CenterX
        loadButton.Height == self.Height
        
        loadingIndicator.CenterX == loadButton.CenterX
        loadingIndicator.CenterY == loadButton.CenterY
        
        setSuccessStatus()
        
        // content
        loadingIndicator.color = .accent
        loadButton.tintColor = .red
        loadButton.titleLabel?.numberOfLines = 2
    }
    
    func setLoadingStatus() {
        loadingIndicator.startAnimating()
        loadButton.backgroundColor = .primary
        loadButton.text("")
        loadButton.setImage(nil, for: .normal)
        loadingIndicator.isHidden = false
    }
    
    func setSuccessStatus() {
        loadButton.textKey("BUTTON_LOAD_MORE")
        loadButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Dimens.font_size_headings)
        loadButton.backgroundColor = .primary_dark
        
        turnOffLoadingIndicator()
        
        loadButton.titleEdgeInsets = .zero
    }
    
    func setErrorStatus(message: String) {
        loadButton.text(message + " " + NSLocalizedString("TRY_AGAIN", comment: ""))
        loadButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.font_size_main)
        loadButton.backgroundColor = .placeholder
        loadButton.setImage(errorIcon, for: .normal)
        
        turnOffLoadingIndicator()
        
        loadButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: Dimens.padding_viewport, bottom: 0, right: 0)
        loadButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: Dimens.padding_viewport * 2, bottom: 0, right: Dimens.padding_viewport)
    }
    
    func turnOffLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
}
