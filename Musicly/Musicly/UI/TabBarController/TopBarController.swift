//
//  TopBarController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit


class TopBarController: UITabBarController {
    
    
    let yStatusBar = UIApplication.shared.statusBarFrame.size.height + 45
    
    var dataSource = ListControllerDataSource()
    
    var store: iTrackDataStore? = iTrackDataStore(realmClient: RealmClient())
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(self.tabBar)
        self.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.blue, size: CGSize(width: self.tabBar.frame.width/CGFloat(self.tabBar.items!.count), height: self.tabBar.frame.height), lineWidth: 2.0)
    }
    
    private func setupTabs() {
        super.viewDidLoad()
        setupControllers()
    }
    
    private func setupControllers() {
        UITabBar.appearance().tintColor = UIColor.orange
        let tracksController = TracksViewController()
        let playlistController = TracksViewController()
        let searchTab = setupSearchTab(tracksViewController: tracksController)
        let playlistTab = setupPlaylistTab(playlistViewController: playlistController)
        let controllers = [searchTab, playlistTab]
        setTabTitles(controllers: controllers)
    }
    
    private func setupSearchTab(tracksViewController: TracksViewController) -> UINavigationController {
        let dataSource = ListControllerDataSource()
        dataSource.store = self.store
        tracksViewController.dataSource = dataSource
        
        tracksViewController.tabBarItem = UITabBarItem(title: "Two", image: nil, selectedImage: #imageLiteral(resourceName: "Rectangle 2").withRenderingMode(.alwaysOriginal))
        let tracksTab = UINavigationController(rootViewController: tracksViewController)
        return tracksTab
    }
    
    private func setupPlaylistTab(playlistViewController: TracksViewController) -> UINavigationController {
        let dataSource = ListControllerDataSource()
        dataSource.store = store
        playlistViewController.dataSource = dataSource
        playlistViewController.tabBarItem = UITabBarItem(title: "Two", image: nil, selectedImage: #imageLiteral(resourceName: "Rectangle 2").withRenderingMode(.alwaysOriginal))
        let playlistTab = UINavigationController(rootViewController: playlistViewController)
        return playlistTab
    }
    
    private func setTabTitles(controllers: [UINavigationController]) {
        viewControllers = controllers
        tabBar.items?[0].title = "Tracks"
        tabBar.items?[1].title = "Playlist"
        selectedIndex = 0
    }
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(x: 0,y :size.height - lineWidth), size: CGSize(width: size.width, height: lineWidth)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
