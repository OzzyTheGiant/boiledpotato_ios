import UIKit

/** A custom UITextField that adds padding to text, placeholder, and edit rectangles */
class UIPaddedTextField : UITextField {
    let padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    
    required init?(coder aDecoder: NSCoder?) {
        fatalError("init(coder:) is not implemented")
    }
    
    /** custom initializer for app's fields */
    convenience init(hint placeholder: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        self.placeholder = NSLocalizedString("SEARCH_FIELD_PLACEHOLDER", comment: "")
        self.backgroundColor = .white
        self.layer.borderWidth = 0
        self.layer.cornerRadius = Dimens.border_radius_main
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func textRect(forBounds bounds: CGRect) ->  CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
