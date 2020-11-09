import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get("lister", use: list)
        todos.get("users", use: user)
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":todoID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        return Todo.query(on: req.db).all()
    }
    
    func user(req: Request) throws -> EventLoopFuture<View> {
        
        let result = Todo.query(on: req.db).all()
        
        struct AllUsersContext: Codable {
            var titles: [String]
            //var items: [Todo]
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            print("posting todo")
            
        })
        
        let todo = Todo(title: "TEST TODOoo").save(on: req.db)
        
        return result.flatMap { object -> EventLoopFuture<View> in
            let foo = object.map{$0.title}
            let context = AllUsersContext(titles: foo)
            print("OBJECT \(context.titles)")
            return req.view.render("altPage", context)
        }
    }
    
    func list(req: Request) throws -> EventLoopFuture<View> {
        let result = Todo.query(on: req.db).all()
        
        
        return result.flatMap { object -> EventLoopFuture<View> in
            let context = Context(items: object)
           
            return req.view.render("page", context)
        }
        
        //return
        
        struct Context: Codable {
            var items: [Todo]
        }
        
        //let compress = screen.cascade(to: {$0})
        
        //let context = Context(items: [])
        //return req.view.render("page", context)
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
        let todo = try req.content.decode(Todo.self)
        return todo.save(on: req.db).map { todo }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
