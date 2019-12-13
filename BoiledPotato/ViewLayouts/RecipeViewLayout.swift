import UIKit
import Stevia

class RecipeViewLayout {
    let scrollView            = UIScrollView()
    let scrollViewContent     = UIView()
    let headerComponent       = UITransparentHeaderView(true)
    let recipeImage           = UIImageView()
    let recipeTitleBackground = UIView()
    let recipeTitle           = UILabel()
    let recipeLabels          = UIRecipeLabels(servings: 0, prepTime: 0)
    let recipeIngredients     = UIRecipeDetailsView(titleKey: "INGREDIENTS").style(component)
    let recipeInstructions    = UIRecipeDetailsView(titleKey: "INSTRUCTIONS", color: .white).style(component)
    let errorComponent        = UIErrorView(true)
    
    func arrangeSubviews(for parent: UIView) {
        parent.sv(
            scrollView.sv(
                scrollViewContent.sv(
                    recipeImage,
                    headerComponent,
                    recipeTitleBackground,
                    recipeTitle,
                    recipeLabels,
                    recipeIngredients,
                    recipeInstructions,
                    errorComponent
                )
            )
        )
        
        // styles
        parent.backgroundColor = .white
        recipeTitleBackground.backgroundColor = .accent
        recipeTitle.textColor = .white
        errorComponent.isHidden = true
        
        // constraints
        scrollView.Top == parent.layoutMarginsGuide.Top
        scrollView.Width == parent.Width
        scrollView.Bottom == parent.Bottom
        
        scrollViewContent.Top == scrollView.Top
        scrollViewContent.Width == parent.Width
        scrollViewContent.Bottom == recipeInstructions.Bottom
        
        headerComponent.Top == scrollViewContent.Top
        headerComponent.Left == scrollViewContent.Left
        headerComponent.Right == scrollViewContent.Right
        headerComponent.activateSubviewConstraints()
        headerComponent.constrainBottom()
        
        recipeImage.Top == scrollViewContent.Top
        recipeImage.Left == scrollViewContent.Left
        recipeImage.Right == scrollViewContent.Right
        recipeImage.height(Dimens.recipe_image_height)
        
        recipeTitleBackground.Top == recipeImage.Bottom
        recipeTitleBackground.Left == scrollViewContent.Left
        recipeTitleBackground.Right == scrollViewContent.Right
        
        recipeTitle.Top == recipeTitleBackground.layoutMarginsGuide.Top
        recipeTitle.Left == recipeTitleBackground.layoutMarginsGuide.Left
        recipeTitle.Right == recipeTitleBackground.layoutMarginsGuide.Right
        recipeTitle.Bottom == recipeTitleBackground.layoutMarginsGuide.Bottom
        
        recipeLabels.Top == recipeTitleBackground.Bottom
        recipeLabels.Left == scrollViewContent.Left
        recipeLabels.Right == scrollViewContent.Right
        recipeLabels.activateSubviewConstraints()
        
        recipeIngredients.Top == recipeLabels.Bottom
        recipeIngredients.Left ==  scrollViewContent.Left
        recipeIngredients.Right == scrollViewContent.Right
        
        recipeInstructions.Top == recipeIngredients.Bottom
        recipeInstructions.Left ==  scrollViewContent.Left
        recipeInstructions.Right == scrollViewContent.Right
        
        recipeIngredients.arrangeShimmerViews()
        recipeInstructions.arrangeShimmerViews()
        
        errorComponent.Top == recipeLabels.Bottom
        errorComponent.Left == scrollViewContent.Left
        errorComponent.Right == scrollViewContent.Right
        errorComponent.Bottom == recipeInstructions.Bottom
    }
    
    func setContent(recipe: Recipe, imageBaseUrl: String) {
        recipeImage.kf.setImage(with: URL(string: imageBaseUrl + recipe.imageFileName))
        recipeTitle.text = recipe.name
        recipeTitle.font = UIFont.systemFont(ofSize: Dimens.font_size_headings)
        recipeLabels.setLabelData(servings: recipe.servings, prepTime: recipe.prepMinutes)
    }
    
    func setUpScrollViewContentSize(rootViewSize: CGSize) {
        scrollView.contentSize.height = scrollViewContent.frame.size.height
        scrollView.contentSize.width = rootViewSize.width
    }
}
