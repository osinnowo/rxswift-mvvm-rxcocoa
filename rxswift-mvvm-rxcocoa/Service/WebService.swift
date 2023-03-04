//
//  WebService.swift
//  rxswift-mvvm-rxcocoa
//
//  Created by Emmanuel Osinnowo on 04/03/2023.
//

import UIKit
import RxSwift

enum Environment: String {
    case production
    case premise
    case staging
    
    var plistName: String {
        switch self {
            case .production: return "Production"
            case .premise: return "Premise"
            case .staging: return "Staging"
        }
    }
    
    func getUrl() -> URL? {
        guard let plistPath = Bundle.main.path(forResource: plistName, ofType: "plist"),
              let plistData = try? Data(contentsOf: URL(fileURLWithPath: plistPath)),
              let plist = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil),
              let url = (plist as? [String: Any])?["url"] as? String else {
            return nil
        }
        return URL(string: url)
    }
}

enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case OPTIONS
}

enum WebServiceError: Error {
    case decodeError
}

struct Empty: Codable {}

protocol WebServiceProtocol {
    associatedtype T: Codable
    associatedtype R: Decodable
    
    func initiate(environment: Environment, method: HttpMethod, request: T?) -> Observable<R>
}

final class WebService<Request: Codable, Response: Decodable> : WebServiceProtocol {

    typealias T = Request

    typealias R = Response
    
    func initiate(
        environment: Environment,
        method: HttpMethod = .GET,
        request: Request? = nil
    ) -> Observable<Response> {
        return Observable.create { observer in
            var urlRequest = URLRequest(url: environment.getUrl()!)
            urlRequest.httpMethod = method.rawValue
           
            if let requestBody = request {
               let jsonData = try! JSONEncoder().encode(requestBody)
               urlRequest.httpBody = jsonData
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else { return }
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    observer.onNext(response)
                } catch {
                    observer.onError(WebServiceError.decodeError)
                }
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
}
