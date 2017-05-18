//
//  NavigationCoordinator.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/16/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit


protocol Coordinator {
    var navigationController: UINavigationController { get set }
}

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let startController = StartViewController()
        startController.delegate = self
    }
}

extension AppCoordinator: StartViewControllerDelegate {
    func loginSelected() {
        self.navigationController.pushViewController(LoginViewController(), animated: false)
    }

    func createAccountSelected() {
        self.navigationController.pushViewController(CreateAccountViewController(), animated: false)
    }

    func continueAsGuestSelected() {
        self.navigationController = UINavigationController(rootViewController: TabBarController())
    }
}

