//
//  File.swift
//  
//
//  Created by Matthew Wylder on 3/9/22.
//

import Fluent

struct CreateAddressContactPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("address-contact-pivot")
            .id()
            .field("addressID", .uuid, .required, .references("addresses", "id", onDelete: .cascade))
            .field("contactID", .uuid, .required, .references("contacts", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("address-contact-pivot").delete()
    }
}
