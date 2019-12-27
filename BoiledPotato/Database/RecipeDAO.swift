import SQLite
import PromiseKit

class RecipeDAO {
    private let db : Connection?
    private let querySchema    = RecipeSearchQuerySchema()
    private let resultsSchema  = RecipeSearchResultsSchema()
    private let recipeSchema   = RecipeSchema()
    private let favoriteSchema = FavoriteSchema()
    
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
                
                try db.run(favoriteSchema.table.create(ifNotExists: true) { table in
                    table.column(favoriteSchema.recipeId)
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
                
                seal.fulfill(try RecipeSearchQuery(from: row.decoder(), madeBySQLite: true))
            } catch {
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
                return seal.fulfill(query)
            }
            
            if let db = db {
                
                /* Query: SELECT R.* FROM Recipes as R JOIN SearchResults as S ON R.ID = S.RecipeID
                WHERE S.SearchID = :searchId LIMIT :limit OFFSET :offset */
                let sqlQuery = recipeSchema.table
                    .join(resultsSchema.table, on: recipeSchema.id == resultsSchema.recipeId)
                    .where(resultsSchema.queryId == query.id)
                    .limit(limit, offset: offset)
                
                do {
                    // create a new Recipe object for each db row found
                    for row in try db.prepare(sqlQuery) {
                        query.recipes!.append(try Recipe(from: row.decoder(), madeBySQLite: true))
                    }
                } catch {}
            }
            
            seal.fulfill(query)
        }
    }
    
    func save(recipe: Recipe) -> Promise<Recipe> {
        return Promise { resolver in
            try db?.run(recipeSchema.table.insert(or: .replace, encodable: recipe))
            resolver.fulfill(recipe)
        }
    }
    
    func getFavoriteRecipes(resultSize: Int, offset: Int, getCount: Bool) -> Promise<RecipeSearchQuery> {
        return Promise { resolver in
            var query = RecipeSearchQuery()
            query.recipes = []
            
            if let db = db {
                if getCount {
                    query.totalResults = try db.scalar(favoriteSchema.table.count)
                }
                
                if query.totalResults > 0 {
                    /* Query: SELECT * FROM Recipes JOIN Favorites ON Recipes.ID == Favorites.RecipeID */
                    let sqlQuery = recipeSchema.table
                        .join(favoriteSchema.table, on: recipeSchema.id == favoriteSchema.recipeId)
                        .limit(resultSize, offset: offset)
                    
                    for row in try db.prepare(sqlQuery) {
                        query.recipes!.append(try Recipe(from: row.decoder(), madeBySQLite: true))
                    }
                }
            }
            
            if query.totalResults == 0 { throw DataError.noResultsFound }
            resolver.fulfill(query)
        }
    }
    
    func getFavorite(recipeId: Int) -> Promise<Bool> {
        return Promise { resolver in
            let recipe = try db?.pluck(favoriteSchema.table.where(favoriteSchema.recipeId == recipeId))
            resolver.fulfill(recipe != nil)
        }
    }
    
    func delete(favorite recipeId: Int) -> Promise<Bool> {
        return Promise { resolver in
            try db?.run(favoriteSchema.table.where(favoriteSchema.recipeId == recipeId).delete())
            resolver.fulfill(false)
        }
    }
    
    func save(favorite recipeId: Int) -> Promise<Bool> {
        return Promise { resolver in
            try db?.run(favoriteSchema.table.insert(Favorite(recipeId: recipeId)))
            resolver.fulfill(true)
        }
    }
    
    func saveAll(query: RecipeSearchQuery) -> Promise<Void> {
        return Promise { resolver in
            try db?.transaction {
                let queryId : CLong
                let newId = CLong( try db!.run(querySchema.table.insert(or: .ignore, encodable: query)) )
                
                // use existing id for saving data or new id if query is new
                queryId = query.id == 0 ? newId : query.id
                
                try query.recipes!.forEach { recipe in
                    let searchResult = RecipeSearchResult(queryId: queryId, recipeId: recipe.id)
                    
                    try db!.run(recipeSchema.table.insert(or: .replace, encodable: recipe))
                    try db!.run(resultsSchema.table.insert(or: .replace, encodable: searchResult))
                }
                
                resolver.fulfill(())
            }
        }
    }
}
