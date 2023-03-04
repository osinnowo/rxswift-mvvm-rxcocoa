//
//  AppCoordinator.swift
//  rxswift-mvvm-rxcocoa
//
//  Created by Emmanuel Osinnowo on 04/03/2023.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
