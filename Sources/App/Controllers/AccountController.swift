//
//  AccountController.swift
//  KSMoney
//
//  Created by niuhui on 2017/7/14.
//
//
import Vapor
import HTTP

class AccountController {

    func registeredRouting() {
        let account = token.grouped("account")
        account.get(handler: self.getAccounts)
    }
    func getAccounts(_ request: Request) throws -> ResponseRepresentable {
        
        let user = request.user()
        
        let accounts = try Account.makeQuery().filter("uuid", user?.uuid).first()
        
        
        return try JSON(node: [
            code: 0,
            msg: "success",
            "accounts": accounts.makeNode(in: nil)
            ])        
    }
}
