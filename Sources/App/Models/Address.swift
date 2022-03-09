//
//  Address.swift
//  
//
//  Created by Matthew Wylder on 2/22/22.
//

import Fluent
import Vapor

final class Address: Model, Content {
    static let schema = "addresses"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "address1")
    var address1: String
    
    @Field(key: "address2")
    var address2: String
    
    @Field(key: "city")
    var city: String
    
    @Field(key: "state_province")
    var stateProvince: String
    
    @Field(key: "postal_code")
    var postalCode: String
    
    @Siblings(through: AddressContactPivot.self,
              from: \.$address,
              to: \.$contact)
    var contact: [Contact]
    
    init() { }
    init(id: UUID? = nil, address1: String, address2: String, city: String, stateProvince: String, postalCode: String) {
        self.id = id
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.stateProvince = stateProvince
        self.postalCode = postalCode
    }
}
