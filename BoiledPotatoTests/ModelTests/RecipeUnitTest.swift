import XCTest
@testable import Boiled_Potato

class RecipeUnitTest : XCTestCase {
    let sampleRecipe = Recipe(
        id: 100100,
        name: "Chicken Soup",
        prepMinutes: 60,
        image: "chicken-soup.jpg",
        servings: 4,
        ingredients: ["ingredient 1", "ingredient 2"],
        instructions: ["instruction 1", "instruction 2"]
    )
    
    let jsonData = Data("""
    {
        "id": 100100,
        "title": "Chicken Soup",
        "readyInMinutes": 60,
        "image": "chicken-soup.jpg",
        "servings": 4,
        "extendedIngredients": [
            {"originalString": "ingredient 1"},
            {"originalString": "ingredient 2"}
        ],
        "analyzedInstructions":[
            {
                "steps":[
                    { "step": "instruction 1" }
                ]
            },
            {
                "steps":[
                    { "step": "instruction 2" }
                ]
            }
        ]
    }
    """.utf8)
    
    let incompleteData = Data("""
    { "id": 100100 }
    """.utf8)
    
    private func compareRecipes(_ recipe: Recipe) {
        XCTAssertEqual(sampleRecipe.id, recipe.id)
        XCTAssertEqual(sampleRecipe.name, recipe.name)
        XCTAssertEqual(sampleRecipe.servings, recipe.servings)
        XCTAssertEqual(sampleRecipe.prepMinutes, recipe.prepMinutes)
        XCTAssertEqual(sampleRecipe.imageFileName, recipe.imageFileName)
    }
    
    func testJSONDecoderCreatesRecipe() throws {
        compareRecipes(try JSONDecoder().decode(Recipe.self, from: jsonData))
    }
    
    func testDecoderThrowsErrorIfDataMissing() throws {
        let keyName = "title"
        XCTAssertThrowsError(try JSONDecoder().decode(Recipe.self, from: incompleteData)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual(keyName, key.stringValue, "Expected missing key '\(key.stringValue)' to equal \(keyName)")
            } else {
                XCTFail("Expected '.keyNotFound(\(keyName))")
            }
        }
    }
}
