import UIKit
import Stevia

class UIRecipeLabels : UIView {
    let servingsImageView = UIImageView()
    let prepTimeImageView = UIImageView()
    let servingsLabel = UILabel().style(text_recipe_label)
    let prepTimeLabel = UILabel().style(text_recipe_label)
    
    convenience init(servings: Int, prepTime: Int) {
        self.init()
        self.sv(servingsLabel, servingsImageView, prepTimeLabel, prepTimeImageView)
        
        self.style(component)
        self.backgroundColor = .neutral
        
        // fonts
        let font = UIFont.systemFont(ofSize: Dimens.font_size_main)
        servingsLabel.font = font
        prepTimeLabel.font = font
        
        // icons
        let size = CGSize(width: Dimens.icon_size_cuisine, height: Dimens.icon_size_cuisine)
        servingsImageView.image = UIImage(named:"ICO_Servings")?.resized(to: size).withRenderingMode(.alwaysTemplate)
        prepTimeImageView.image = UIImage(named:"ICO_Prep_Time")?.resized(to: size).withRenderingMode(.alwaysTemplate)
        servingsImageView.tintColor = .primary
        prepTimeImageView.tintColor = .primary
        
        setLabelData(servings: servings, prepTime: prepTime)
    }
    
    func activateSubviewConstraints() {
        servingsLabel.Left == self.layoutMarginsGuide.Left
        servingsLabel.Right == self.CenterX
        
        servingsImageView.Top == self.layoutMarginsGuide.Top
        servingsImageView.CenterX == servingsLabel.CenterX
        servingsImageView.Bottom == servingsLabel.Top - Dimens.margin_main
        
        prepTimeLabel.Left == self.CenterX
        prepTimeLabel.Right == self.layoutMarginsGuide.Right
        
        prepTimeImageView.Top == self.layoutMarginsGuide.Top
        prepTimeImageView.Bottom == prepTimeLabel.Top - Dimens.margin_main
        prepTimeImageView.CenterX == prepTimeLabel.CenterX
        
        self.Bottom == servingsLabel.Bottom - Dimens.padding_viewport
    }
    
    func setLabelData(servings: Int, prepTime: Int) {
        servingsLabel.text = "\(String(servings)) \(NSLocalizedString("SERVINGS", comment: ""))"
        prepTimeLabel.text = "\(String(prepTime)) \(NSLocalizedString("MINUTES", comment: ""))"
    }
}
