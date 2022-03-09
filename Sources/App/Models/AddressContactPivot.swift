//
//  AddressContactPivot.swift
//  
//
//  Created by Matthew Wylder on 3/9/22.
//

import Fluent

final class AddressContactPivot: Model {
    static let schema = "address-contact-pivot"
    
    @ID
    var id: UUID?
    
    @Parent(key: "addressID")
    var address: Address
    
    @Parent(key: "contactID")
    var contact: Contact
    
    init() { }
    
    init(id: UUID? = nil, address: Address, contact: Contact) throws {
        self.id = id
        self.$address.id = try address.requireID()
        self.$contact.id = try contact.requireID()
    }
}
