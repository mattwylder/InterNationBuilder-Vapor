//
//  CreateContact.swift
//  
//
//  Created by Matthew Wylder on 2/22/22.
//

import Fluent

struct CreateContact: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("contacts")
            .id()
            .field("first_name", .string, .required)
            .field("last_name", .string)
            .field("phone", .string)
            .field("email", .string)
            .field("support_level", .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("contacts").delete()
    }
}
