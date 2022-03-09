//
//  File.swift
//  
//
//  Created by Matthew Wylder on 3/9/22.
//

import Fluent

struct CreateAddresses: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("addresses")
            .id()
            .field("address1", .string, .required)
            .field("address2", .string)
            .field("city", .string)
            .field("state_province", .string)
            .field("postal_code", .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("contacts").delete()
    }
}
