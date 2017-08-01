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
        //account.post(handler: self.postTally)
        let allAccount = token.grouped("tallys")
        allAccount.get(handler: self.getAllTallys)

    }

    func getTallys(_ request: Request) throws -> ResponseRepresentable {
        let user = request.user()
        var tallys = [Tally]()
        var tallyQuery = try Tally.makeQuery().filter("uuid", user?.uuid)

        if let account_id = request.data["account_id"]?.int, account_id != 0 {
            tallyQuery = try tallyQuery.filter("account_id", account_id)
        }

        var size = 10

        if let page_size = request.data["pagesize"]?.int {
            if page_size != 0 {
                size = page_size
            }
        }
        if let page = request.data["pagenum"]?.int {
            tallys = try tallyQuery.limit(size, offset: (page-1)*size).all()
        } else {
            tallys = try tallyQuery.limit(size, offset: 0).all()
        }

        return try JSON(node: [
            code: 0,
            msg: "success",
            "count": [
                "total":tallys.count,
            ],
            "tallys": tallys.makeNode(in: nil)
            ])
    }

    /*func postTally(_ request: Request) throws -> ResponseRepresentable {
        let user = request.user()
        
    }*/

    //获取
    func getAllTallys(_ request: Request) throws -> ResponseRepresentable {
        var allTallys = [Tally]()
        var allTallyQuery = try Tally.makeQuery();
        if let account_id = request.data["account_id"]?.int {
            allTallyQuery = try allTallyQuery.filter("account_id", account_id)
        }

        var size = 10
        if let page_size = request.data["pagesize"]?.int {
            if page_size != 0 {
                size = page_size
            }
        }
        if let page = request.data["pagenum"]?.int {
            allTallys = try allTallyQuery.limit(size, offset: page-1).all()
        } else {
            allTallys = try allTallyQuery.limit(size, offset: 0).all()
        }

        return try JSON(node: [
            code: 0,
            msg: "success",
            "count": [
                "total":allTallys.count,
            ],
            "tallys": allTallys.makeNode(in: nil)
            ])
    }

}
