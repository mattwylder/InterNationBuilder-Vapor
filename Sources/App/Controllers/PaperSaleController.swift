//
//  PaperSaleController.swift
//  
//
//  Created by Matthew Wylder on 3/7/22.
//

import Fluent
import Vapor

struct PaperSaleController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let paperRoutes = routes.grouped("paper_sales")
        paperRoutes.get(use: index)
        paperRoutes.get(":paperSaleID", use: fetch)
        paperRoutes.post(use: create)
    }
    
    func index(req: Request) async throws -> [PaperSaleResponseData] {
        let paperSales = try await PaperSale.query(on: req.db)
                                        .join(Contact.self,
                                              on: \PaperSale.$purchaser.$id == \Contact.$id)
                                        .all().get()
        var results: [PaperSaleResponseData] = []
        for paperSale in paperSales {
            let contact = try paperSale.joined(Contact.self)
            let data = PaperSaleResponseData(id: try paperSale.requireID(),
                                             purchaserName: contact.first_name,
                                             purchaserID: try contact.requireID(),
                                             date: paperSale.date,
                                             amount: paperSale.amount)
            results.append(data)
        }
        
        return results
    }
    
    func fetch(req: Request) async throws -> PaperSaleResponseData {
        guard let paperSale = try await PaperSale.find(req.parameters.get("paperSaleID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let purchaser = try await paperSale.$purchaser.get(on: req.db)
        return PaperSaleResponseData(id: try paperSale.requireID(),
                                     purchaserName: purchaser.first_name,
                                     purchaserID: try purchaser.requireID(),
                                     date: paperSale.date,
                                     amount: paperSale.amount)
    }
    
    func create(req: Request) async throws -> HTTPStatus {
        let data = try req.content.decode(CreatePaperSaleData.self)
        let paperSale = PaperSale(purchaserID: data.purchaserID,
                                  amount: data.amount,
                                  date: Date())
        try await paperSale.save(on: req.db)
        return .created
    }
}

struct CreatePaperSaleData: Content {
    let purchaserID: UUID
    let amount: Int
}

struct PaperSaleResponseData: Content {
    let id: UUID
    let purchaserName: String
    let purchaserID: UUID
    let date: Date
    let amount: Int
}
