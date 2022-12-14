import Foundation

protocol APIProtocol {
    var method: HttpMethod { get }
    var url: URL? { get }
}

protocol Gettable: APIProtocol { }

protocol Postable: APIProtocol {
    var identifier: String { get }
    var contentType: String { get }
    var body: Data? { get }
}

enum HttpMethod {
    case get
    case post
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
