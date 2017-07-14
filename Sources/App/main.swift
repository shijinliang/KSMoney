


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



AccountController().registeredRouting()
SignController().registeredRouting()
LoadController().registeredRouting()
UserController().registeredRouting()


try drop.run()


extension Request {
    func user() -> User? {
        do {
            guard let token = self.data["access_token"]?.string else{return nil}
            guard let session = session_caches[token] else {return nil}
            var user : User?
            if let user_cach = user_caches[session.uuid.string] {
                user = user_cach
            } else {
                guard let user_db = try User.makeQuery().filter("id", session.user_id).first() else {
                    return nil;
                }
                user_caches[session.uuid.string] = user_db
                user = user_db
            }
            return user
        } catch {
            return nil
        }
    }

}
