//
//  PaperSale.swift
//  
//
//  Created by Matthew Wylder on 3/4/22.
//

import Fluent
import Vapor

final class PaperSale: Content, Model {
    
    static let schema = "paper_sales"
    
    @ID(key: .id)
    var id: UUID?
    
    //TODO: DTO, query to flatten name and contact info of purchaser
    @Parent(key: "purchaser_id")
    var purchaser: Contact
    
    @Field(key: "amount")
    var amount: Int
    
    @Field(key: "date")
    var date: Date
    
    init() { }
    
    init(id: UUID? = nil, purchaserID: Contact.IDValue, amount: Int, date: Date) {
        self.id = id
        self.$purchaser.id = purchaserID
        self.amount = amount
        self.date = date
    }
}
