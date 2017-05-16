//
//  UIViewController+Extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/13/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupDefaultUI() {
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.textColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.textColor
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for tracks...", attributes: [NSForegroundColorAttributeName: UIColor.white])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
    }
    
    func setSearchBarColor(searchBar: UISearchBar) {
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
    }
}

extension UIViewController {
    
    func showError(_ title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let OKString = NSLocalizedString("OK", comment: "OK")
        let OKAction = UIAlertAction(title: OKString, style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension UINavigationController {
    
    func index(of type: UIViewController.Type)-> Int? {
        return self.viewControllers.index(where: { vc in
            type(of: vc) == type
        })
    }
    
}
