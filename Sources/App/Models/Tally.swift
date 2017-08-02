//
//  Tally.swift
//  KSMoney
//
//  Created by xiaoshi on 2017/7/22.
//
//

import Vapor
import FluentProvider
import Crypto

final class Tally: Model {
    var uuid            : String = ""
    var category_id     : Int = 0
    var create_at       : Int = 0
    var remark          : String = ""
    var out_account_id  : Int = 0
    var in_account_id   : Int = 0
    var account_id      : Int = 0
    var price           : Float = 0.00
    var state           : Int = 0

    let storage = Storage()

    init() {
        self.category_id = 1
        self.account_id = 1
    }
    init(uuid: String) throws {
        self.uuid = uuid
    }

    init(row: Row) throws {
        uuid = try row.get("uuid")
        category_id = try row.get("category_id")
        create_at = try row.get("create_at")
        remark = try row.get("remark")
        out_account_id = try row.get("out_account_id")
        in_account_id = try row.get("in_account_id")
        account_id = try row.get("account_id")
        price = try row.get("price")
        state = try row.get("state")
    }
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("uuid", uuid)
        try row.set("category_id", category_id)
        try row.set("create_at", create_at)
        try row.set("remark", remark)
        try row.set("out_account_id", out_account_id)
        try row.set("in_account_id", in_account_id)
        try row.set("account_id", account_id)
        try row.set("price", price)
        try row.set("state", state)
        return row
    }
}

extension Tally: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { tally in
            tally.id()
            tally.string("uuid")
            tally.int("category_id")
            tally.int("create_at")
            tally.string("remark")
            tally.int("out_account_id")
            tally.int("in_account_id")
            tally.int("account_id")
            tally.float("price", precision: 2)
            tally.int("state")
        }
    }
    static func revert(_ database: Database) throws {

    }
}

extension Tally {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("uuid", uuid)
        //try json.set("category_id", category_id)
        try json.set("category", getCategory()?.makeJSON())
        try json.set("create_at", create_at)
        try json.set("remark", remark)
        try json.set("out_account_id", out_account_id)
        try json.set("in_account_id", in_account_id)
        try json.set("account_id", account_id)
        if out_account_id > 0 {
            try json.set("out_account", getAccount(out_account_id)?.makeJSON())
        }
        if in_account_id > 0 {
            try json.set("in_account", getAccount(in_account_id)?.makeJSON())
        }
        if account_id > 0 {
            try json.set("account", getAccount(account_id)?.makeJSON())
        }
        try json.set("price", price)
        try json.set("state", state)
        return json
    }
}

extension Tally: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("id", id)
        try node.set("uuid", uuid)
        //try node.set("category_id", category_id)
        try node.set("category", getCategory()?.makeJSON())
        try node.set("create_at", create_at)
        try node.set("remark", remark)
        try node.set("out_account_id", out_account_id)
        try node.set("in_account_id", in_account_id)
        try node.set("account_id", account_id)
        if out_account_id > 0 {
            try node.set("out_account", getAccount(out_account_id)?.makeJSON())
        }
        if in_account_id > 0 {
            try node.set("in_account", getAccount(in_account_id)?.makeJSON())
        }
        if account_id > 0 {
            try node.set("account", getAccount(account_id)?.makeJSON())
        }

        try node.set("price", price)
        try node.set("state", state)
        return node
    }
}

extension Tally {
    func getCategory() throws -> Category? {
        if let category = try Category.makeQuery().filter("id", category_id).first() {
            return category
        } else {
            return nil
        }
    }

    func getAccount(_ id: Int) throws -> Account? {
        if let account = try Account.makeQuery().filter("id", id).first() {
            return account
        } else {
            return nil
        }
    }
}
