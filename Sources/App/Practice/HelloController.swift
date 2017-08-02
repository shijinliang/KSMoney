//
//  HelloController.swift
//  KSMoney
//
//  Created by xiaoshi on 2017/8/2.
//
//

import Vapor
import HTTP

final class HelloController {
    func sayHello(_ req: Request) throws -> ResponseRepresentable {
        guard let name = req.data["data"]?.string else { throw Abort(.badRequest) }
        return "Hello, \(name)"
    }

    func sayHelloAlternate(_ req: Request) throws -> ResponseRepresentable {
        let name: String = try req.parameters.next(String.self)
        return "Hello, \(name)"
    }
}
