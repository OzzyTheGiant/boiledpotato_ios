import UIKit

func component(_ view: UIView) {
    let p = Dimens.padding_viewport
    // this is equivalent to using directionalLayoutMargins
    view.top(p).bottom(p).left(p).right(p)
}

func component_placeholders(_ placeholderComponent: UIStackView) {
    component(placeholderComponent)
    placeholderComponent.axis = .vertical
    placeholderComponent.distribution = .fillEqually
    placeholderComponent.alignment = .center
    placeholderComponent.spacing = Dimens.padding_viewport
}

func button_icon(_ button: UIButton) {
    button.tintColor = .primary
    button.layer.cornerRadius = Dimens.border_radius_main
    button.size(Dimens.button_size_main)
}

func button_icon_primary(_ button: UIButton) {
    button_icon(button)
    button.backgroundColor = .primary
    button.tintColor = .neutral
}

func button_text_primary(_ button: UIButton) {
    let p = Dimens.padding_button_text
    button.top(p).bottom(p).left(p).right(p)
    button.backgroundColor = .primary_dark
    button.layer.cornerRadius = Dimens.border_radius_main
    button.setTitleColor(.neutral, for: UIButton.State.normal)
}

func text_heading(_ label: UILabel) {
    label.font = UIFont.systemFont(ofSize: Dimens.font_size_headings, weight: UIFont.Weight.bold)
    label.textAlignment = .center
}

func text_heading_view_layout(_ label: UILabel) {
    text_heading(label)
    label.textColor = .primary
}

func text_recipe_label(_ label: UILabel) {
    label.textColor = .primary
    label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    label.textAlignment = .center
}

func description(_ label: UILabel) {
    label.textAlignment = .center
}

func placeholder(_ view: UIView) {
    view.backgroundColor = .placeholder
}

func placeholder_neutral(_ view: UIView) {
    view.backgroundColor = .neutral
}
