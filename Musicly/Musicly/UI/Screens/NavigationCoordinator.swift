//
//  NavigationCoordinator.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/16/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol Coordinated {
    var coordinationDelegate: CoordinationDelegate? { get set }
}

protocol CoordinationDelegate {
    func coordinateTransitionFrom(source: Coordinated, toDestination destination: UIViewController)
}


protocol Coordinator {
    var navigationController: UINavigationController { get set }
}


protocol RootViewControllerProvider: class {
    // The coordinators 'rootViewController'. It helps to think of this as the view
    // controller that can be used to dismiss the coordinator from the view hierarchy.
    var rootViewController: UIViewController { get }
}

/// A Coordinator type that provides a root UIViewController
typealias RootViewCoordinator = Coordinator & RootViewControllerProvider

class AppCoordinator: RootViewCoordinator, SplashControllerDelegate {
    
    func moveToStart() {
        print("fuck you")
    }
    
    var rootViewController: UIViewController
    let splashController = SplashViewController()
    
    var navigationController: UINavigationController {
        didSet {
            navigationController.isNavigationBarHidden = true
        }
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.rootViewController = navigationController
        splashController.delegate = self 
    }
    
    func splash() {
        self.navigationController.pushViewController(splashController, animated: false)
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

//extension AppCoordinator: SplashControllerDelegate {
//    
//    func moveToStart() {
//        print("Move to start")
//        let startController = StartViewController()
//        startController.delegate = self
//        navigationController.pushViewController(startController, animated: false)
//    }
//}

