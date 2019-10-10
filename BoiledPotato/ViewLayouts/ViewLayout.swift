import UIKit

class ViewLayout {
    func createComponent() -> UIView {
        let view = UIView()
        let p = Dimens.padding_viewport
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .neutral
        
        if #available(iOS 11.0, *) {
            view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: p, leading: p, bottom: p, trailing: p)
        } else {
            view.layoutMargins = UIEdgeInsets(top: p, left: p, bottom: p, right: p)
        }
        
        return view
    }
    
    func createIconButton(withImageAsset assetName: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: assetName), for: UIControl.State.normal)
        button.tintColor = .primary
        return button
    }
    
    func createIconButton(withImageAsset assetName: String, color: UIColor) -> UIButton {
        let button = createIconButton(withImageAsset: assetName)
        button.backgroundColor = .primary
        button.tintColor = .neutral
        button.layer.cornerRadius = Dimens.border_radius
        return button
    }
    
    func createViewLayoutTitle(key: String) -> UILabel {
        let label = UILabel()
        label.text = NSLocalizedString(key, comment: "")
        label.font = UIFont.systemFont(ofSize: Dimens.font_size_headings, weight: UIFont.Weight.bold)
        label.textColor = .primary
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createField(placeholder: String) -> UIPaddedTextField {
        let searchField = UIPaddedTextField()
        searchField.backgroundColor = .white
        searchField.placeholder = NSLocalizedString(placeholder, comment: "")
        searchField.layer.borderWidth = 0
        searchField.layer.cornerRadius = Dimens.border_radius
        searchField.translatesAutoresizingMaskIntoConstraints = false
        return searchField
    }
}
