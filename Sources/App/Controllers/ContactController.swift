//
//  ContactController.swift
//  
//
//  Created by Matthew Wylder on 2/22/22.
//

import Fluent
import Vapor

struct ContactController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let contactRoutes = routes.grouped("contacts")
        contactRoutes.get(use: indexWithAddresses)
        contactRoutes.post(use: createWithAddress)
    }
    
    func index(request: Request) async throws -> [Contact] {
        return try await Contact.query(on: request.db).all()
    }
    
    func create(request: Request) async throws -> HTTPStatus {
        let contact = try request.content.decode(Contact.self)
        try await contact.save(on: request.db)
        return .created
    }
    
    func createWithAddress(req: Request) async throws -> HTTPStatus {
        let data = try req.content.decode(CreateContactData.self)
        let contact = Contact(first_name: data.first_name,
                              last_name: data.last_name,
                              phone: data.phone,
                              email: data.email,
                              support_level: data.supportLevel)
        
        try await contact.save(on: req.db)
        
        for address in data.addresses {
            try await address.save(on: req.db)
            try await AddressContactPivot(address: address,
                                          contact: contact)
                .save(on: req.db)
        }
        
        return .created
    }
    
    //TODO: There's probably a better way than this loop
    func indexWithAddresses(req: Request) async throws -> [ContactResponseData] {
        let contacts = try await Contact.query(on: req.db).all()
        var results = [ContactResponseData]()
        
        for contact in contacts {
            let addresses = try await contact.$addresses.get(on: req.db)
            let data = ContactResponseData(id: try contact.requireID(),
                                           firstName: contact.first_name,
                                           lastName: contact.last_name,
                                           email: contact.email,
                                           phone: contact.phone,
                                           supportLevel: contact.support_level,
                                           addresses: addresses)
            results.append(data)
        }
        return results
    }
}

struct CreateContactData: Content {
    let first_name: String
    let last_name: String
    let phone: String
    let email: String
    let supportLevel: Contact.SupportLevel
    let addresses: [Address]
}

struct ContactResponseData: Content {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let supportLevel: Contact.SupportLevel
    let addresses: [Address]
}
