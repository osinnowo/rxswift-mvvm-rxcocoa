//
//  UserListViewModel.swift
//  rxswift-mvvm-rxcocoa
//
//  Created by Emmanuel Osinnowo on 04/03/2023.
//

import UIKit
import RxSwift


final class UserListViewModel {
    let title = "Users"
    
    private var userService: UserServiceProtocol
    
    public init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func fetchUserViewModels() -> Observable<[UserViewModel]> {
        return userService.fetchUsers().map { $0.map { UserViewModel(user: $0) } }
    }
}
