import Foundation
@testable import Boiled_Potato

class TestData {
    static let sampleRecipe = Recipe(
        id: 100100,
        name: "Chicken Soup",
        prepMinutes: 60,
        image: "chicken-soup.jpg",
        servings: 4,
        ingredients: ["ingredient 1", "ingredient 2"],
        instructions: ["instruction 1", "instruction 2"]
    )
    
    static let sampleQuery = RecipeSearchQuery(
        id: 0,
        keywords: "Chicken",
        cuisine: "Mexican",
        totalResults: 25,
        expires: 9999999999999999
    )
    
    static let incompleteData = Data("""
    { "id": 100100 }
    """.utf8)
}
