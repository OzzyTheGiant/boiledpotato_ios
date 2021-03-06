import UIKit
import Stevia
import Kingfisher

class UIRecipeCard : UICollectionViewCell {
    static let id = "RecipeCard"
    
    weak var recipeImageView : UIImageView!
    weak var recipeLabel : UILabel!
    public var recipeImage : UIImage!
    
    
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
        recipeImage.backgroundColor = .white
        
        // recipe image constraints
        recipeImage.height(Dimens.recipe_thumbnail_height)
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
        self.recipeImageView = recipeImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.recipeLabel.text = nil
    }
    
    /** Set the text of the recipe card as a formatted string */
    func setText(_ recipeTitle: String) {
        let attributedString = NSMutableAttributedString(string: recipeTitle)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = Dimens.line_spacing_recipe_card
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        recipeLabel.attributedText = attributedString
    }
    
    func setImage(withFileName fileName: String) {
        // NOTE: this processor may need to be replaced by ResizingImageProcessor if images are too blurry on landscape mode
        let imageProcessor =
            ResizingImageProcessor(referenceSize: recipeImageView!.frame.size, mode: .aspectFill) |>
            CroppingImageProcessor(size: recipeImageView!.frame.size)
        
        let options: KingfisherOptionsInfo = [
            .processor(imageProcessor),
            .scaleFactor(recipeImageView.contentScaleFactor),
            .transition(.fade(0.3)),
            .cacheOriginalImage
        ]
        
        recipeImageView.kf.indicatorType = .activity
        recipeImageView.kf.setImage(with: URL(string: fileName), options: options)
    }
}
