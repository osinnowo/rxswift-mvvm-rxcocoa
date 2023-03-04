//
//  UserViewModel.swift
//  rxswift-mvvm-rxcocoa
//
//  Created by Emmanuel Osinnowo on 04/03/2023.
//

import UIKit

struct UserViewModel {
    private let user: User
    
    var displayText: String {
        return user.name + " - " + user.username
    }
    
    init(user: User) {
        self.user = user
    }
}
