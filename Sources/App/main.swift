


import Vapor

let config = try Config()
try config.setup()
let drop = try Droplet(config)

drop.database?.log = { query in
    print(query)
}
/// 基础api
let api   = drop.grouped("api")
let v1    = api.grouped("v1")
let token = v1.grouped(TokenMiddleware())

try drop.run()
