import Foundation

struct ItunesAPI {
    static let baseURL = "http://itunes.apple.com"
    
    // http://itunes.apple.com/lookup?media=software&country=kr&id=872469884
    struct AppLookup: Gettable {
//        private let baseURL = ItunesAPI.baseURL
//        private let appID: String
//        private var path = "/lookup"
//        private var country = "kr"
//        var parameters: [String : String] {
//            return [
//                "country": country,
//                "media": "software",
//                "id": "\(appID)"
//            ]
//        }
//        var url: URL? {  // TODO: 개선
//            return URL(string: "\(baseURL)\(path)\(parameters)")
//        }
        
        let method: HttpMethod = .get
        var url: URL?
        
        init(
            appID: String,
            baseURL: String = baseURL
        ) {
//            self.appID = appID
            
            var urlComponents = URLComponents(string: "\(baseURL)/lookup?")
            let mediaQuery = URLQueryItem(name: "media", value: "software")
            let countryQuery = URLQueryItem(name: "country", value: "kr")
            let searchTextQuery = URLQueryItem(name: "id", value: "\(appID)")
            urlComponents?.queryItems?.append(
                contentsOf: [mediaQuery, countryQuery, searchTextQuery]
            )
            
            self.url = urlComponents?.url
        }
    }
    
}
