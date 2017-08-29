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
    var uuid        : String = ""
    var create_at   : Int = 0
    var image       : String = ""
    var type        : Int = 0   //1现金 2储蓄卡 3信用卡 4虚拟 5债务
    var balance     : Float = 0
    init(row: Row) throws {
        name = try row.get("name")
        create_at = try row.get("create_at")
        image = try row.get("image")
        type = try row.get("type")
        uuid = try row.get("uuid")
        balance = try row.get("balance")
    }
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("create_at", create_at)
        try row.set("image", image)
        try row.set("type", type)
        try row.set("uuid", uuid)
        try row.set("balance", balance)
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
            users.int("type")
            users.string("uuid")
            users.float("balance")
        }
    }
    static func revert(_ database: Database) throws {

    }
}

extension Account {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        try json.set("create_at", create_at)
        try json.set("image", image)
        try json.set("type", type)
        try json.set("uuid", uuid)
        return json
    }
}
extension Account: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("id", id)
        try node.set("uuid", uuid)
        try node.set("create_at", create_at)
        try node.set("image", image)
        try node.set("type", type)
        try node.set("name", name)
        return node
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


