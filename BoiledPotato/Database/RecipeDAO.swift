import SQLite
import PromiseKit

class RecipeDAO {
    private let db : Connection?
    private let querySchema   = RecipeSearchQuerySchema()
    private let resultsSchema = RecipeSearchResultsSchema()
    private let recipeSchema  = RecipeSchema()
    
    init(db: Connection?) {
        self.db = db
        
        if let db = db {
            do {  // initialize database tables when starting application
                try db.execute("")
                
                try db.run(querySchema.table.create(ifNotExists: true) { table in
                    table.column(querySchema.id, primaryKey: .autoincrement)
                    table.column(querySchema.searchKeywords, unique: true)
                    table.column(querySchema.cuisine)
                    table.column(querySchema.totalResults)
                    table.column(querySchema.expires)
                })
                
                try db.run(recipeSchema.table.create(ifNotExists: true) { table in
                    table.column(recipeSchema.id, primaryKey: true)
                    table.column(recipeSchema.name)
                    table.column(recipeSchema.prepMinutes)
                    table.column(recipeSchema.imageFileName)
                    table.column(recipeSchema.servings)
                    table.column(recipeSchema.ingredients)
                    table.column(recipeSchema.instructions)
                })
                
                try db.run(resultsSchema.table.create(ifNotExists: true) { table in
                    table.column(resultsSchema.queryId)
                    table.column(resultsSchema.recipeId)
                    table.primaryKey(resultsSchema.queryId, resultsSchema.recipeId) // composite
                    table.foreignKey(resultsSchema.queryId, references: querySchema.table, querySchema.id)
                    table.foreignKey(resultsSchema.recipeId, references: recipeSchema.table, recipeSchema.id)
                })
            } catch {} // effectively allows app to run without database cache
        }
    }
    
    /** Get RecipeSearchQuery from database using search keywords and cuisine type */
    func getSearchQuery(with keywords: String, filteredBy cuisine: String) -> Promise<RecipeSearchQuery> {
        return Promise { seal in
            /*  Query: SELECT * FROM SearchQueries WHERE Keywords = :keywords AND Cuisine = :cuisine */
            let sqlQuery = querySchema.table.where(querySchema.searchKeywords == keywords && querySchema.cuisine == cuisine)
            
            do {
                // return query from db or an empty query with id of 0 if it does not exist or other error occurs
                guard let row = try db?.pluck(sqlQuery) else {
                    throw DataError.noResultsFound
                }
                
                print("Search query was previously cached in database")
                seal.fulfill(try RecipeSearchQuery(from: row.decoder()))
            } catch {
                print("Search query is brand new. Returning new RecipeSearchQuery object")
                seal.fulfill(RecipeSearchQuery())
            }
        }
    }
    
    /** Get Recipes that were part of a search query when fetched from network API */
    func getRecipes(bySearchQuery query: RecipeSearchQuery, limit: Int, offset: Int) -> Promise<RecipeSearchQuery> {
        return Promise { seal in
            var query = query; query.recipes = []
            
            // return early if query has never been cached or had no recipes in results
            if query.id == 0 || query.totalResults == 0 {
                print("Query is brand new or cached query has no recipes. Aborting")
                return seal.fulfill(query)
            }
            
            if let db = db {
                
                /* Query: SELECT R.* FROM Recipes as R JOIN SearchResults as S ON R.ID = S.RecipeID
                WHERE S.SearchID = :searchId LIMIT :limit OFFSET :offset */
                let sqlQuery = recipeSchema.table
                    .join(resultsSchema.table, on: recipeSchema.id == resultsSchema.recipeId)
                    .where(recipeSchema.id == query.id)
                    .limit(limit, offset: offset)
                
                do {
                    // create a new Recipe object for each db row found
                    for row in try db.prepare(sqlQuery) {
                        query.recipes!.append(try Recipe(from: row.decoder(), madeBySQLite: true))
                    }
                } catch {}
            }
            
            print("Cached query had recipes in database. Proceeding")
            seal.fulfill(query)
        }
    }
    
    func save(recipe: Recipe) -> Promise<Recipe> {
        return Promise { resolver in
            try db?.run(recipeSchema.table.insert(or: .replace, encodable: recipe))
            print("Recipe updated with details")
            resolver.fulfill(recipe)
        }
    }
    
    func saveAll(query: RecipeSearchQuery) -> Promise<Void> {
        return Promise { resolver in
            try db?.transaction {
                let queryId = CLong( try db!.run(querySchema.table.insert(or: .replace, encodable: query)) )
                
                try query.recipes!.forEach { recipe in
                    let searchResult = RecipeSearchResult(queryId: queryId, recipeId: recipe.id)
                    
                    try db!.run(recipeSchema.table.insert(or: .replace, encodable: recipe))
                    try db!.run(resultsSchema.table.insert(or: .replace, encodable: searchResult))
                }
                
                print("All data saved")
                resolver.fulfill(())
            }
        }
    }
}