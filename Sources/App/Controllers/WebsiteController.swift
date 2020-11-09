//
//  WebsiteController.swift
//  
//
//  Created by Erik Hatfield on 9/19/20.
//

import Fluent
import Vapor

struct WebsiteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let make = routes.grouped("make")
        make.get(use: base)
        make.post(use: this)
    }
    
    func base(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("make")
    }
    
    func this(req: Request) throws -> EventLoopFuture<[Todo]> {
        print("req bod \(req.body)")
        return Todo.query(on: req.db).all()
    }
}
