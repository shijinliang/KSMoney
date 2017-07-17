//
//  Account.swift
//  KSMoney
//
//  Created by niuhui on 2017/7/14.
//
//
import Vapor
import FluentProvider
import Crypto

final class Account: Model{

    let storage = Storage()
    var name        : String = ""
    var create_at   : Int = 0
    var image       : String = ""
    var image_tag   : String = ""
    var type        : String = ""
    init(row: Row) throws {
        name = try row.get("name")
        create_at = try row.get("create_at")
        image = try row.get("image")
    }
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("create_at", create_at)
        try row.set("image", image)
        return row
    }
}
extension Account: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { users in
            users.id()
            users.string("name")
            users.int("create_at")
            users.string("image")
        }
    }
    static func revert(_ database: Database) throws {

    }
}
//添加字段
//struct addAccountHHHH: Preparation {
//    static func prepare(_ database: Database) throws {
//        try database.modify(Account.self, closure: { (bar) in
//            bar.string("HHHH")
//        })
//    }
//    static func revert(_ database: Database) throws {
//        
//    }
//}


