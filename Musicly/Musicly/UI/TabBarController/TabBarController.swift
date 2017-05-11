//
//  TabBarController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // Accessible in Tabbar child controllers
    
    var store: iTrackDataStore? = iTrackDataStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTabBar(tabBar: tabBar, view: view)
    }
    
    // General dimensions and look of tabbar
    
    private func setupTabBar(tabBar: UITabBar, view: UIView) {
        var tabFrame = tabBar.frame
        let tabBarHeight = view.frame.height * Tabbar.tabbarFrameHeight
        tabFrame.size.height = tabBarHeight
        tabFrame.origin.y = view.frame.size.height - tabBarHeight
        tabBar.frame = tabFrame
        tabBar.isTranslucent = true
    }
    
    private func setupTabs() {
        super.viewDidLoad()
        setupControllers(tracksController: TracksViewController(), playlistController: PlaylistsViewController())
    }
    
    private func setupControllers(tracksController: TracksViewController, playlistController: PlaylistsViewController) {
        UITabBar.appearance().tintColor = UIColor.orange
        let searchTab = setupSearchTab(tracksViewController: tracksController)
        let playlistTab = setupPlaylistTab(playlistsViewController: playlistController)
        let controllers = [searchTab, playlistTab]
        setTabTitles(controllers: controllers)
    }
    
    private func setTabTitles(controllers: [UINavigationController]) {
        viewControllers = controllers
        tabBar.items?[0].title = "Tracks"
        tabBar.items?[1].title = "Playlist"
        selectedIndex = 0
    }
    
    private func setupSearchTab(tracksViewController: TracksViewController) -> UINavigationController {
        let normalImage = #imageLiteral(resourceName: "blue-dj")
        let selectedImage = #imageLiteral(resourceName: "orangedj")
        let dataSource = TracksViewControllerDataSource()
        dataSource.store = store
        tracksViewController.tabBarItem = UITabBarItem(title: nil, image: normalImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysTemplate))
        
        let tracksTab = UINavigationController(rootViewController: tracksViewController)
        return tracksTab
    }
    
    private func setupPlaylistTab(playlistsViewController: PlaylistsViewController) -> UINavigationController {
        let selectedImage = #imageLiteral(resourceName: "orange-soundwave")
        let normalImage = #imageLiteral(resourceName: "blue-soundwave")
        let dataSource = PlaylistsViewControllerDataSource()
        dataSource.store = store
        playlistsViewController.dataSource = dataSource
        playlistsViewController.tabBarItem = UITabBarItem(title: nil, image: normalImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysTemplate))
        playlistsViewController.tabBarItem.selectedImage = selectedImage
        let playlistTab = UINavigationController(rootViewController: playlistsViewController)
        return playlistTab
    }
}
