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

    init(row: Row) throws {
        try name = row.get("name")
        try create_at = row.get("create_at")
        try parent_id = row.get("parent_id")
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name);
        try row.set("create_at", create_at)
        try row.set("parent_id", parent_id)
        return row;
    }
}

extension Category : Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (category) in
            category.id()
            category.string("name")
            category.int("create_at")
            category.int("parent_id")
        })

    }
    static func revert(_ database: Database) throws {

    }
}
