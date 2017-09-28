//
//  Category.swift
//  KSMoney
//
//  Created by xiaoshi on 2017/7/22.
//
//

import Vapor
import FluentProvider
import Crypto

final class Category:Model {
    let storage = Storage()

    var name        : String = ""
    var create_at   : Int = 0
    var parent_id   : Int = 0
    var parent_name : String = ""
    var uuid        : String = ""
    
    init(row: Row) throws {
        try name = row.get("name")
        try create_at = row.get("create_at")
        try parent_id = row.get("parent_id")
        try uuid = row.get("uuid")
    }
    init(uuid: String) {
        self.uuid = uuid
    }
    init(time: Int) {
        self.create_at = time
    }
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name);
        try row.set("create_at", create_at)
        try row.set("parent_id", parent_id)
        try row.set("uuid", uuid)
        return row;
    }
}

//创建数据库
extension Category : Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (category) in
            category.id()
            category.string("name")
            category.int("create_at")
            category.int("parent_id")
            category.string("uuid")
        })

    }
    static func revert(_ database: Database) throws {

    }
}

extension Category {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        try json.set("create_at", create_at)
        try json.set("parent_id", parent_id)
        try json.set("uuid", uuid)

        if parent_id == 0 {
            try json.set("parent_name", "")
        } else {
            try json.set("parent_name", self.getName())
        }
        return json
    }
}
extension Category: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("id", id)
        try node.set("name", name)
        try node.set("create_at", create_at)
        try node.set("parent_id", parent_id)
        //try node.set("uuid", uuid)
        if parent_id == 0 {
            try node.set("parent_name", "")
        } else {
            try node.set("parent_name", self.getName())
        }
        return node
    }
}

extension Category {
    func getName() throws -> String? {
        if let category = try Category.makeQuery().filter("id", self.parent_id).limit(1).first() {
            return category.name
        } else {
            return nil
        }
    }
}
