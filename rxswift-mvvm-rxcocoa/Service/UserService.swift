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
        return WebService<Empty, [User]>()
                   .initiate(
                        environment: .production,
                        method: .GET,
                        request: nil
                   ) .map { $0 }
    }
}
