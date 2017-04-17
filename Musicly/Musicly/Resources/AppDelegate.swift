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
        let viewController = SplashViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let placeholderAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: UIColor.blue,
            NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)
        ]
        
        let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
        
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        UINavigationBar.appearance().tintColor = NavigationBarAttributes.navBarTint
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: ApplicationConstants.mainFont!,
            NSForegroundColorAttributeName: ApplicationConstants.fontColor
        ]
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
}
