//
//  CreatePaperSales.swift
//  
//
//  Created by Matthew Wylder on 3/9/22.
//

import Fluent

struct CreatePaperSales: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("paper_sales")
            .id()
            .field("purchaser_id", .uuid, .required, .references("contacts", "id"))
            .field("amount", .int, .required)
            .field("date", .date, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("paper_sales").delete()
    }
}
