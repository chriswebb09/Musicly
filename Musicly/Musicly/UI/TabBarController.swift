//
//  TabBarController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    var store: iTrackDataStore = iTrackDataStore(searchTerm: "")
    
    override func viewDidLoad() {
        store.setSearch(string: "new")
        view.backgroundColor = .white
        setupTabs()
    }
    
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
        tabBar.isTranslucent = false
    }
    
    func setupTabs() {
        super.viewDidLoad()
        setupControllers()
    }
    
    fileprivate func setupControllers() {
        UITabBar.appearance().tintColor = UIColor.orange
        let tracksController = TracksViewController()
        tracksController.store = store
        let playlistController = PlaylistViewController()
        playlistController.store = store
        let searchTab = setupSearchTab(tracksViewController: tracksController)
        let playlistTab = setupPlaylistTab(playlistViewController: playlistController)
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
        var normalImage = #imageLiteral(resourceName: "blue-dj")
        var selectedImage = #imageLiteral(resourceName: "orangedj")
        tracksViewController.tabBarItem = UITabBarItem(title: nil, image: normalImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysTemplate))
        
        let tracksTab = UINavigationController(rootViewController: tracksViewController)
        return tracksTab
    }
    
    fileprivate func setupPlaylistTab(playlistViewController: PlaylistViewController) -> UINavigationController {
        var selectedImage = #imageLiteral(resourceName: "orange-soundwave")
        var normalImage = #imageLiteral(resourceName: "blue-soundwave")
        playlistViewController.tabBarItem = UITabBarItem(title: nil, image: normalImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysTemplate))
        playlistViewController.tabBarItem.selectedImage = selectedImage
        let playlistTab = UINavigationController(rootViewController: playlistViewController)
        return playlistTab
    }
    
    func configureTabBarItem(item: UITabBarItem) {
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.normal)
        item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0)], for:.selected)
    }
}
