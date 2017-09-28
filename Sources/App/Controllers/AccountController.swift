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
        account.post(handler: self.addAccount)
    }
    func getAccounts(_ request: Request) throws -> ResponseRepresentable {
        
        let user = request.user()
        
        let accounts = try Account.makeQuery().filter("uuid", user?.uuid).all()
        
        
        return try JSON(node: [
            code: 0,
            msg: "success",
            "accounts": accounts.makeNode(in: nil)
            ])        
    }
    
    func addAccount(_ request: Request) throws -> ResponseRepresentable {
        print(request.query ?? "没有参数")
        let user = request.user()
        let account = Account(uuid: (user?.uuid)!)
        if let name = request.data["name"]?.string {
            account.name = name
        } else {
            return try JSON(node: [
                code: 1,
                msg : "名字不能为空"
                ])
        }
        if let type = request.data["type"]?.int {
            account.type = type
        } else {
            return try JSON(node: [
                code: 1,
                msg : "type不能为空"
                ])
        }
        if let balance = request.data["balance"]?.float {
            account.balance = balance
        }
        account.create_at = Int(Date().timeIntervalSince1970)
        
        try account.save()
        return try JSON(node: [
            code:0,
            msg:"success",
            "id":account.id!
            ])
    }
}
