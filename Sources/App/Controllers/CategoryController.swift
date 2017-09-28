//
//  CategoryController.swift
//  App
//
//  Created by xiaoshi on 2017/9/28.
//

import Vapor
import HTTP

class CategoryController {
    func registeredRouting() {
        let group = token.grouped("category")
        group.get(handler: self.getCategorys)
        group.get("base", handler: self.getBaseCategorys)
        group.post(handler: self.addCategory)
        group.post("super", handler: self.addSuperCategory)
    }
    
    func getCategorys(_ request: Request) throws -> ResponseRepresentable {
        var categorys = [Category]()
        let user = request.user()
        let query = try Category.makeQuery().filter("uuid", user?.uuid)
        
        categorys = try query.all()
        return try JSON(node: [
            code: 0,
            msg: "success",
            "categorys":categorys.makeNode(in: nil)
            ])
    }
    
    func getBaseCategorys(_ request: Request) throws -> ResponseRepresentable {
        var categorys = [Category]()
        let query = try Category.makeQuery().filter("parent_id", 0)
        categorys = try query.all()
        return try JSON(node: [
            code: 0,
            msg: "success",
            "categorys":categorys.makeNode(in: nil)
            ])
    }
    
    func addCategory(_ request: Request) throws -> ResponseRepresentable {
        let user = request.user()
        let category = Category.init(uuid: (user?.uuid)!)
        if let name = request.data["name"]?.string {
            category.name = name
        } else {
            return try JSON(node: [
                code: 1,
                msg: "名字不能为空"
                ])
        }
        if let pID = request.data["p_id"]?.string {
            category.parent_id = Int(pID)!
        } else {
            return try JSON(node: [
                code: 1,
                msg: "二级分类不能没有父分类"
                ])
        }
        category.create_at = Int(Date().timeIntervalSince1970)
        try category.save()
        return try JSON(node: [
            code: 0,
            msg: "success",
            "category_id": category.id!
            ])
    }
    
    func addSuperCategory(_ request: Request) throws -> ResponseRepresentable {
        let time = Int(Date().timeIntervalSince1970)
        let category = Category.init(time: time)
        if let name = request.data["name"]?.string {
            category.name = name
            let superArray = try Category.makeQuery().filter("parent_id", 0).filter("name", name).all()
            if superArray.count>0 {
                return try JSON(node: [
                    code: 1,
                    msg: "名字已存在"
                    ])
            }
        } else {
            return try JSON(node: [
                code: 1,
                msg: "名字不能为空"
                ])
        }
        
        try category.save()
        return try JSON(node: [
            code: 0,
            msg: "success",
            "category_id": category.id!
            ])
    }
}
