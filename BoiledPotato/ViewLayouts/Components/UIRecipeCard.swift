import UIKit
import Stevia

class UIRecipeCard : UICollectionViewCell {
    static let id = "RecipeCard"
    
    weak var recipeImage : UIImageView!
    weak var recipeLabel : UILabel!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let recipeImage = UIImageView()
        let recipeLabel = UILabel()
        
        self.contentView.sv(recipeImage, recipeLabel)
        self.contentView.layer.masksToBounds = true // for corner radius
        self.contentView.layer.cornerRadius = Dimens.border_radius_cuisine
        
        // coloring
        self.contentView.backgroundColor = .accent
        recipeLabel.textColor = .white
        recipeImage.backgroundColor = .primary_dark
        
        // recipe image constraints
        recipeImage.height(Dimens.recipe_image_height)
        recipeImage.Top == self.contentView.Top
        recipeImage.Left == self.contentView.Left
        recipeImage.Right == self.contentView.Right

        // recipe label constraints
        recipeLabel.Top == recipeImage.Bottom
        recipeLabel.Bottom == self.contentView.Bottom
        recipeLabel.Left == self.contentView.Left + Dimens.padding_viewport
        recipeLabel.Right == self.contentView.Right - Dimens.padding_viewport
        
        recipeLabel.numberOfLines = 2
        
        self.recipeLabel = recipeLabel
        self.recipeImage = recipeImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.recipeLabel.text = nil
    }
    
    func setText(_ recipeTitle: String) {
        let attributedString = NSMutableAttributedString(string: recipeTitle)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = Dimens.line_spacing_recipe_card
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        recipeLabel.attributedText = attributedString
    }
}
