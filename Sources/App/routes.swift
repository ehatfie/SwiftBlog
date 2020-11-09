import Fluent
import Vapor

struct Item: Codable {
    var title: String
    var description: String
}

func routes(_ app: Application) throws {
    app.get { req -> EventLoopFuture<View> in
        struct Context: Codable {
            var items: [Item]
        }
        
        let context = Context(items: [
            .init(title: "#01", description: "Description #01"),
            .init(title: "#02", description: "Description #02"),
            .init(title: "#03", description: "Description #03"),
            .init(title: "#04", description: "Description #04"),
        ])
        
        return req.view.render("page", context)
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("create") { req -> String in
        let todos = [
            Todo(title: "Publish new article tomorrow"),
            Todo(title: "Finish Fluent tutorial"),
            Todo(title: "Write more blog posts"),
        ]
        
        return "Hello, world!"
    }
    
    app.get("list") { req -> String in
        let foo = Todo.query(on: req.db).all()
        //let result = try? foo.
        
//        if let values = result {
//            return "this: \(values.count)"
//        }
        
        return "helllo"
    }
    
    
    try app.register(collection: TodoController())
    try app.register(collection: WebsiteController())
}
