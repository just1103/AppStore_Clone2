import Foundation

struct ItunesAPI {
    static let baseURL = "http://itunes.apple.com"
    
    struct AppLookup: Gettable {
        private let baseURL = ItunesAPI.baseURL
        private let appID: String
        let method: HttpMethod = .get
        private var path = "/lookup"
        private var country = "kr"
        var parameters: [String : String] {
            return [
                "country": country,
                "media": "software",
                "id": "\(appID)"
            ]
        }
        var url: URL? {
            return URL(string: "\(baseURL)\(path)\(parameters)")
        }
        
        init(appID: String) {
            self.appID = appID
        }
    }
}
