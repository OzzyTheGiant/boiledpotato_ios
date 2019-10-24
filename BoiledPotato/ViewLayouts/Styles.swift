import UIKit

func component(_ view: UIView) {
    let p = Dimens.padding_viewport
    // this is equivalent to using directionalLayoutMargins
    view.top(p).bottom(p).left(p).right(p)
}

func component_background_neutral(_ view: UIView) {
    component(view)
    view.backgroundColor = .neutral
}

func component_placeholders(_ placeholderComponent: UIStackView) {
    component(placeholderComponent)
    placeholderComponent.axis = .vertical
    placeholderComponent.distribution = .fillEqually
    placeholderComponent.alignment = .center
    placeholderComponent.spacing = Dimens.padding_viewport
}

func button_icon(_ button: UIButton, iconKey assetName: String) {
    button.setBackgroundImage(UIImage(named: assetName), for: UIControl.State.normal)
    button.tintColor = .primary
    button.layer.cornerRadius = Dimens.border_radius_main
    button.size(Dimens.button_size_main)
}

func button_icon_primary(_ button: UIButton, iconKey assetName: String) {
    button_icon(button, iconKey: assetName)
    button.backgroundColor = .primary
    button.tintColor = .neutral
}

func button_icon_back(_ button: UIButton) { button_icon(button, iconKey: "ICO_Back_Arrow") }
func button_icon_star(_ button: UIButton) { button_icon(button, iconKey: "ICO_Star") }
func button_icon_search(_ button: UIButton) { button_icon_primary(button, iconKey: "ICO_Search") }

func text_heading(_ label: UILabel, key: String) {
    label.text = NSLocalizedString(key, comment: "")
    label.font = UIFont.systemFont(ofSize: Dimens.font_size_headings, weight: UIFont.Weight.bold)
    label.textAlignment = NSTextAlignment.center
}

func text_heading_view_layout(_ label: UILabel, key: String) {
    text_heading(label, key: key)
    label.textColor = .primary
}

func paragraph(_ label: UILabel, key: String, alignment : NSTextAlignment = .left) {
    label.text = NSLocalizedString(key, comment: "")
    label.preferredMaxLayoutWidth = Dimens.max_text_width
    label.textAlignment = alignment
}

func text_heading_vl_main(_ label: UILabel) { text_heading_view_layout(label, key: "MAIN_VIEW_TITLE") }
func text_heading_vl_search(_ label: UILabel) { text_heading_view_layout(label, key: "SEARCH_RESULTS_VIEW_TITLE") }
func text_heading_cuisine(_ label: UILabel) { text_heading(label, key: "CUISINE_HEADING") }
func text_paragraph_cuisine(_ label: UILabel) { paragraph(label, key: "CUISINE_PARAGRAPH", alignment: .center) }

func field(_ field: UITextField, placeholder: String) {
    field.backgroundColor = .white
    field.placeholder = NSLocalizedString(placeholder, comment: "")
    field.layer.borderWidth = 0
    field.layer.cornerRadius = Dimens.border_radius_main
}

func field_search(_ textField: UITextField) { field(textField, placeholder: "SEARCH_FIELD_PLACEHOLDER") }

func placeholder(_ view: UIView) { view.backgroundColor = .placeholder }
