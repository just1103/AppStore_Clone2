import Foundation

protocol ItunesAPIRequestable { }

struct ItunesAPI {
    
    static let baseURL = "http://itunes.apple.com"
    
    struct AppLookup: Gettable, ItunesAPIRequestable {
        // TODO: header 및 decodingType을 가지도록 개선
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
//        var url: URL? {
//            return URL(string: "\(baseURL)\(path)\(parameters)")
//        }
        
        let method: HttpMethod = .get
        var url: URL?
        
        init(
            appID: String,
            baseURL: String = baseURL
        ) {
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
    
    struct AppSearch: Gettable, ItunesAPIRequestable {
        var method: HttpMethod = .get
        var url: URL?
        
        init(
            searchText: String,
            baseURL: String = baseURL
        ) {
            var urlComponents = URLComponents(string: "\(baseURL)/search?")
            let mediaQuery = URLQueryItem(name: "media", value: "software")
            let countryQuery = URLQueryItem(name: "country", value: "kr")
            let limitQuery = URLQueryItem(name: "limit", value: "30")
            let searchTextQuery = URLQueryItem(name: "term", value: "\(searchText)")
            urlComponents?.queryItems?.append(
                contentsOf: [mediaQuery, countryQuery, limitQuery, searchTextQuery]
            )
            
            self.url = urlComponents?.url
        }
    }
    
}
