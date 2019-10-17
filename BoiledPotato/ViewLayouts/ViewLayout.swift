import UIKit

class ViewLayout {
    func createComponent() -> UIView {
        let view = UIView()
        let p = Dimens.padding_viewport
        
        if #available(iOS 11.0, *) {
            view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: p, leading: p, bottom: p, trailing: p)
        } else {
            view.layoutMargins = UIEdgeInsets(top: p, left: p, bottom: p, right: p)
        }
        
        return view
    }
    
    func createComponent(withColor color: UIColor) -> UIView {
        let view = createComponent()
        view.backgroundColor = color
        return view
    }
    
    func createIconButton(withImageAsset assetName: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: assetName), for: UIControl.State.normal)
        button.tintColor = .primary
        button.layer.cornerRadius = Dimens.border_radius_main
        button.size(Dimens.button_size_main)
        return button
    }
    
    func createIconButton(withImageAsset assetName: String, color: UIColor) -> UIButton {
        let button = createIconButton(withImageAsset: assetName)
        button.backgroundColor = .primary
        button.tintColor = .neutral
        return button
    }
    
    func createTextHeading(key: String) -> UILabel {
        let label = UILabel()
        label.text = NSLocalizedString(key, comment: "")
        label.font = UIFont.systemFont(ofSize: Dimens.font_size_headings, weight: UIFont.Weight.bold)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createViewLayoutTitle(key: String) -> UILabel {
        let label = createTextHeading(key: key)
        label.textColor = .primary
        return label
    }
    
    func createField(placeholder: String) -> UIPaddedTextField {
        let field = UIPaddedTextField()
        field.backgroundColor = .white
        field.placeholder = NSLocalizedString(placeholder, comment: "")
        field.layer.borderWidth = 0
        field.layer.cornerRadius = Dimens.border_radius_main
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
    
    func createText(key: String, alignment: NSTextAlignment = NSTextAlignment.left) -> UILabel {
        let label = UILabel()
        label.text = NSLocalizedString(key, comment: "")
        label.preferredMaxLayoutWidth = Dimens.max_text_width
        label.textAlignment = alignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
