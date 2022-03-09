//
//  File.swift
//  
//
//  Created by Matthew Wylder on 3/9/22.
//

import Fluent
import Vapor

struct AddressController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let addressRoutes = routes.grouped("address")
        addressRoutes.get(use: index)
    }
    
    func index(req: Request) async throws -> [Address] {
        return try await Address.query(on: req.db).all()
    }
}
