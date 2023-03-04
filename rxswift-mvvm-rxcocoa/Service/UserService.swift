//
//  UserService.swift
//  rxswift-mvvm-rxcocoa
//
//  Created by Emmanuel Osinnowo on 04/03/2023.
//

import UIKit
import RxSwift

enum UserServiceError: Error {
    case invalidUrl
    case unableToParseResponse
}

protocol UserServiceProtocol: AnyObject {
    func fetchUsers() -> Observable<[User]>
}

final class UserService: UserServiceProtocol {
    
    func fetchUsers() -> Observable<[User]> {
        return Observable.create { observer -> Disposable in
            
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
                observer.on(.error(UserServiceError.invalidUrl))
                return Disposables.create ()
            }
            
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, _, error in
                guard let data = data, error == nil else { return }
                do {
                    let response = try JSONDecoder().decode([User].self, from: data)
                    observer.onNext(response)
                } catch {
                    observer.onError(UserServiceError.unableToParseResponse)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
