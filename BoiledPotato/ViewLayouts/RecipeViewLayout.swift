import UIKit
import Stevia

class RecipeViewLayout {
    let scrollView = UIScrollView()
    let scrollViewContent = UIView()
    let headerComponent = UITransparentHeaderView(true)
    let recipeImage = UIImageView()
    let recipeTitleBackground = UIView()
    let recipeTitle = UILabel()
    let recipeLabels = UIRecipeLabels(servings: 0, prepTime: 0)
    
    func arrangeSubviews(for parent: UIView) {
        parent.sv(
            scrollView.sv(
                scrollViewContent.sv(
                    recipeImage,
                    headerComponent,
                    recipeTitleBackground,
                    recipeTitle,
                    recipeLabels
                )
            )
        )
        
        // styles
        parent.backgroundColor = .white
        recipeTitleBackground.backgroundColor = .accent
        recipeTitle.textColor = .white
        
        // constraints
        scrollView.Top == parent.layoutMarginsGuide.Top
        scrollView.Width == parent.Width
        scrollView.Bottom == parent.Bottom
        
        scrollViewContent.Top == scrollView.Top
        scrollViewContent.Width == parent.Width
        scrollViewContent.Bottom == recipeLabels.Bottom
        
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
