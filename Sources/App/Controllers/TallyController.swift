//
//  TallyController.swift
//  KSMoney
//
//  Created by xiaoshi on 2017/7/22.
//
//

import Vapor
import HTTP

class TallyController {
    func registeredRouting() {
        let account = token.grouped("tally")
        account.get(handler: self.getTallys)
    }
    func getTallys(_ request: Request) throws -> ResponseRepresentable {
        let user = request.user()
        var tallys = [Tally]()
        var tallyQuery = try Tally.makeQuery().filter("uuid", user?.uuid)

        if let account_id = request.data["account_id"]?.int {
            tallyQuery = try tallyQuery.filter("account", account_id)
        }

        var size = 10

        if let page_size = request.data["page_size"]?.int {
            if page_size != 0 {
                size = page_size
            }
        }
        if let page = request.data["pagenum"]?.int {
            tallys = try tallyQuery.limit(size, offset: page-1).all()
        } else {
            tallys = try tallyQuery.limit(size, offset: 0).all()
        }

        return try JSON(node: [
            code: 0,
            msg: "success",
            "tallys": tallys.makeNode(in: nil)
            ])
    }
}
