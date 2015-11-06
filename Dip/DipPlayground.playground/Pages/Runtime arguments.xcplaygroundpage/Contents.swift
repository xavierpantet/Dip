//: [Previous](@previous)

import Dip

let container = DependencyContainer()

/*:

### Runtime arguments

Dip lets you use runtime arguments to register and resolve your components.
Note that __types__, __number__ and __order__ of arguments matters and you can register different factories with different set of runtime arguments for the same protocol. To resolve using one of this factory you will need to pass runtime arguments of the same types, number and in the same order to `resolve` as you used in `register` method.
*/

container.register { (url: NSURL, port: Int) in ServiceImp3(name: "1", baseURL: url, port: port) as Service }
container.register { (port: Int, url: NSURL) in ServiceImp3(name: "2", baseURL: url, port: port) as Service }
container.register { (port: Int, url: NSURL?) in ServiceImp3(name: "3", baseURL: url!, port: port) as Service }
container.register { (port: Int, url: NSURL!) in ServiceImp3(name: "4", baseURL: url, port: port) as Service }

//when
let url: NSURL = NSURL(string: "http://example.com")!
let service1 = container.resolve(url, 80) as Service
let service2 = container.resolve(80, url) as Service
let service3 = container.resolve(80, NSURL(string: "http://example.com")) as Service
let service4 = container.resolve(80, NSURL(string: "http://example.com")! as NSURL!) as Service

(service1 as! ServiceImp3).name
(service2 as! ServiceImp3).name
(service3 as! ServiceImp3).name
(service4 as! ServiceImp3).name

/*:
Note that all of the services were resolved using different factories.

Dip supports up to six runtime arguments. If that is not enougth you can extend container to accept more arguments. Here is how you can extend it to serve seven arguments.
*/

extension DependencyContainer {
    public func register<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(tag tag: Tag? = nil, factory: (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6) -> T) -> DefinitionOf<T> {
        return register(tag: tag, factory: factory, scope: .Prototype) as DefinitionOf<T>
    }
    
    public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(tag tag: Tag? = nil, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) -> T {
        return resolve(tag: tag) { (factory: (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6) -> T) in factory(arg1, arg2, arg3, arg4, arg5, arg6) }
    }
}

/*:
If you find yourself thinking about adding more runtime arguments - stop and think about your design instead. Having too many dependencies could be a sign of some problem in your architecture.
*/

//: [Next](@next)
