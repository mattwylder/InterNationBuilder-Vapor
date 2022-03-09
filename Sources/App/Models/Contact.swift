//
//  Contact.swift
//
//
//  Created by Matthew Wylder on 2/11/22.
//

import Fluent
import Vapor

final class Contact: Model, Content {
    enum SupportLevel: String, Codable {
        case strongSupport = "strong_support"
        case weakSupport = "weak_support"
        case undecided = "undecided"
        case weakOppose = "weak_oppose"
        case strongOppose = "strong_oppose"
        case unidentified = "unidentified"
    }
    
    static let schema = "contacts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "first_name")
    var first_name: String
    
    @Field(key: "last_name")
    var last_name: String
    
    @Field(key: "phone")
    var phone: String
    
    @Field(key: "email")
    var email: String

    @Field(key: "support_level")
    var support_level: SupportLevel
    
    @Siblings(through: AddressContactPivot.self,
              from: \.$contact,
              to: \.$address)
    var addresses: [Address]
    
    init() { }
    
    init(id: UUID? = nil,
         first_name: String,
         last_name: String,
         phone: String,
         email: String,
         support_level: SupportLevel) {
        self.first_name = first_name
        self.last_name = last_name
        self.phone = phone
        self.email = email
        self.support_level = support_level
    }
}
