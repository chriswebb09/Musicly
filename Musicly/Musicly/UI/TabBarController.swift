//
//  TabBarController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupTabs()
    }
    
   var store: iTrackDataStore? = iTrackDataStore(searchTerm: "")
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupTabBar(tabBar: tabBar, view: view)
    }
    
    func setupTabBar(tabBar:UITabBar, view:UIView) {
        var tabFrame = tabBar.frame
        let tabBarHeight = view.frame.height * Tabbar.tabbarFrameHeight
        tabFrame.size.height = tabBarHeight
        tabFrame.origin.y = view.frame.size.height - tabBarHeight
        tabBar.frame = tabFrame
        tabBar.isTranslucent = true
        tabBar.tintColor = Tabbar.tint
    }
    
    func setupTabs() {
        super.viewDidLoad()
        setupControllers()
    }
    
    fileprivate func setupControllers() {
        var tracksController = TracksViewController()
        var playlistController = PlaylistViewController()
        let searchTab = setupSearchTab(tracksViewController: tracksController)
        let playlistTab = setupPlaylistTab(playlistViewController: PlaylistViewController())
        let controllers = [searchTab, playlistTab]
        setTabTitles(controllers: controllers)
    }
    
    private func setTabTitles(controllers: [UINavigationController]) {
        viewControllers = controllers
        tabBar.items?[0].title = "Tracks"
        tabBar.items?[1].title = "Playlist"
        selectedIndex = 0
    }
    
    fileprivate func setupSearchTab(tracksViewController: TracksViewController) -> UINavigationController {
        tracksViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "discturntable")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "discturntable")?.withRenderingMode(.alwaysTemplate))
        configureTabBarItem(item: tracksViewController.tabBarItem)
        let tracksTab = UINavigationController(rootViewController: tracksViewController)
        return tracksTab
    }
    
    fileprivate func setupPlaylistTab(playlistViewController: PlaylistViewController) -> UINavigationController {
        playlistViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "heart")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate))
        configureTabBarItem(item: playlistViewController.tabBarItem)
        let playlistTab = UINavigationController(rootViewController: playlistViewController)
        return playlistTab
    }
    
    func configureTabBarItem(item: UITabBarItem) {
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.normal)
        item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0)], for:.selected)
    }
}
