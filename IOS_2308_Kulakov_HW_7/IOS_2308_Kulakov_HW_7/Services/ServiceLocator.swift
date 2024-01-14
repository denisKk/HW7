
import Foundation

protocol NetworkingService {
    static var service: Self {get}
    
    func fetch(page: Int, limit: Int, completion: @escaping ([ArtworkModel]) -> ())
}

protocol IServiceLocator {
    func service<T>() -> T?
}

final class ServiceLocator: IServiceLocator {
    
    private static let instance = ServiceLocator()
    private lazy var services: [String: Any] = [:]
    
    // MARK: - Public methods
    class func service<T>() -> T? {
        return instance.service()
    }
    
    class func addService<T>(_ service: T) {
        return instance.addService(service)
    }
    
    func service<T>() -> T? {
        let key = typeName(T.self)
        return services[key] as? T
    }
    
    // MARK: - Private methods
    private func addService<T>(_ service: T) {
        let key = typeName(T.self)
        services[key] = service
    }
    
    private func removeService<T>(_ service: T) {
        let key = typeName(T.self)
        services.removeValue(forKey: key)
    }
    
    private func typeName(_ some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }
}

