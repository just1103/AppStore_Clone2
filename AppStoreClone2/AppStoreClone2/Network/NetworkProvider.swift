//
//  URLSessionProtocol.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/07.
//

import RxSwift
import Foundation

struct NetworkProvider {
    private let session: URLSessionProtocol
    private let disposeBag = DisposeBag()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Codable>(api: Gettable, decodingType: T.Type) -> Observable<T> {
        return Observable.create { emitter in
            guard let task = dataTask(api: api, emitter: emitter) else {
                return Disposables.create()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
//    func request(api: Postable) -> Observable<Data> {
//        return Observable.create { emitter in
//            guard let task = dataTask(api: api, emitter: emitter) else {
//                return Disposables.create()
//            }
//            task.resume()
//
//            return Disposables.create {
//                task.cancel()
//            }
//        }
//    }
    
    private func dataTask<T: Codable>(api: APIProtocol, emitter: AnyObserver<T>) -> URLSessionDataTask? {
        guard let urlRequest = URLRequest(api: api) else {
            emitter.onError(NetworkError.urlIsNil)
            return nil
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, _ in
            let successStatusCode = 200..<300
            guard let httpResponse = response as? HTTPURLResponse,
                  successStatusCode.contains(httpResponse.statusCode) else {
                emitter.onError(NetworkError.statusCodeError)
                return
            }
            
            switch api {
            case is Gettable:
                if let data = data {
                    guard let decodedData = JSONParser<T>().decode(from: data) else {
                        emitter.onError(JSONParserError.decodingFail)
                        return
                    }
                    
                    emitter.onNext(decodedData)
                }
            case is Postable:
                if let data = data as? T {
                    emitter.onNext(data)
                }
            default:
                return
            }
            
            emitter.onCompleted()
        }
        
        return task
    }
}
