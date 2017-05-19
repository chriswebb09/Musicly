//
//  AppDelegate.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var backgroundSessionCompletionHandler: (() -> Void)?
    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //let initialViewController = SplashViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
        let coordinator = AppCoordinator(navigationController: UINavigationController())
        //let coordinator = AppCoordinator(navigationController: UINavigationController(rootViewController: initialViewController))
        window?.rootViewController = coordinator.rootViewController
        coordinator.splashController.delegate = coordinator
        coordinator.splash()
        setupUI()
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    
    func setupUI() {
        let placeholderAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: UIColor.blue,
            NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)
        ]
        let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
        UINavigationBar.appearance().tintColor = NavigationBarAttributes.navBarTint
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: ApplicationConstants.mainFont!,
            NSForegroundColorAttributeName: ApplicationConstants.fontColor
        ]
    }
    
}
