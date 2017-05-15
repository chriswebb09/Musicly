import UIKit

final class TabBarController: UITabBarController {
    
    // Accessible in Tabbar child controllers
    
    var store: iTrackDataStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        store = iTrackDataStore()
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
        setupControllers()
    }
    
    private func setupControllers() {
        UITabBar.appearance().tintColor = UIColor.orange
        let tracksController = TopBarController()
        let playlistController = PlaylistsViewController()
        let searchTab = setupSearchTab(tracksViewController: tracksController)
        let playlistTab = setupPlaylistTab(playlistViewController: playlistController)
        //let controllers = [searchTab, playlistTab]
        setTabTitles(controller: searchTab, navController: playlistTab)
    }
    
    private func setTabTitles(controller: UIViewController, navController: UINavigationController) {
        viewControllers = [controller, navController]
        tabBar.items?[0].title = "Tracks"
        tabBar.items?[1].title = "Playlist"
        selectedIndex = 0
    }
    
    private func setupSearchTab(tracksViewController: TopBarController) -> TopBarController {
        let normalImage = #imageLiteral(resourceName: "blue-dj")
        let selectedImage = #imageLiteral(resourceName: "orangedj")
        var dataSource = ListControllerDataSource()
        dataSource.store = self.store
        tracksViewController.dataSource = dataSource
        tracksViewController.tabBarItem = UITabBarItem(title: nil, image: normalImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysTemplate))
        return tracksViewController
    }
    
    private func setupPlaylistTab(playlistViewController: PlaylistsViewController) -> UINavigationController {
        let selectedImage = #imageLiteral(resourceName: "orange-soundwave")
        let normalImage = #imageLiteral(resourceName: "blue-soundwave")
        let dataSource = ListControllerDataSource()
        dataSource.store = store
        playlistViewController.dataSource = dataSource
        playlistViewController.tabBarItem = UITabBarItem(title: nil, image: normalImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysTemplate))
        playlistViewController.tabBarItem.selectedImage = selectedImage
        let playlistTab = UINavigationController(rootViewController: playlistViewController)
        return playlistTab
    }
}
