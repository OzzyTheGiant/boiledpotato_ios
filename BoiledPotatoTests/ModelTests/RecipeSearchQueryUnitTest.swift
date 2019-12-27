import XCTest
@testable import Boiled_Potato

class RecipeSearchQueryUnitTest : XCTestCase {
    let sampleRecipe = Recipe(
        id: 100100,
        name: "Chicken Soup",
        prepMinutes: 60,
        image: "chicken-soup.jpg",
        servings: 4,
        ingredients: nil,
        instructions: nil
    )
    
    let sampleQuery = RecipeSearchQuery(
        id: 0,
        keywords: "Chicken",
        cuisine: "Mexican",
        totalResults: 25,
        expires: 999999999999
    )
    
    let jsonData = Data("""
    {
        "expires": 999999999999,
        "totalResults": 25,
        "results": [
            {
                "id": 100100,
                "title": "Chicken Soup",
                "readyInMinutes": 60,
                "image": "chicken-soup.jpg",
                "servings": 4
            }
        ],
    }
    """.utf8)
    
    let incompleteData = Data("""
    { "id": 100100 }
    """.utf8)
    
    private func compareQueries(_ query: RecipeSearchQuery) {
        XCTAssertEqual(sampleQuery.id, query.id)
        XCTAssertEqual(sampleQuery.expires, query.expires)
        XCTAssertEqual(sampleQuery.totalResults, query.totalResults)
        XCTAssertEqual(1, query.recipes?.count)
        
        XCTAssertEqual(sampleRecipe.id, query.recipes?[0].id)
        XCTAssertEqual(sampleRecipe.name, query.recipes?[0].name)
        XCTAssertEqual(sampleRecipe.prepMinutes, query.recipes?[0].prepMinutes)
        XCTAssertEqual(sampleRecipe.imageFileName, query.recipes?[0].imageFileName)
        XCTAssertEqual(sampleRecipe.servings, query.recipes?[0].servings)
    }
    
    func testJSONDecoderCreatesRecipe() throws {
        compareQueries(try JSONDecoder().decode(RecipeSearchQuery.self, from: jsonData))
    }
    
    func testDecoderThrowsErrorIfDataMissing() throws {
        let keyName = "totalResults"
        XCTAssertThrowsError(try JSONDecoder().decode(RecipeSearchQuery.self, from: incompleteData)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual(keyName, key.stringValue, "Expected missing key '\(key.stringValue)' to equal \(keyName)")
            } else {
                XCTFail("Expected '.keyNotFound(\(keyName))")
            }
        }
    }
}
