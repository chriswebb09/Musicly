import UIKit
import RealmSwift

final class PlaylistViewController: BaseListViewController {
    
    var buttonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dataSource.playlist.itemCount > 0 {
            contentState = .results
            collectionView.isHidden = false
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        title = dataSource.tracklist.listName
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItems = [buttonItem!]
    }
    
    private func commonInit() {
        buttonItem = UIBarButtonItem(image: dataSource.image, style: .plain, target: self, action: #selector(goToSearch))
        
        navigationItem.setRightBarButton(buttonItem, animated: false)
    }
}

extension PlaylistViewController {
    
    func goToSearch() {
        tabBarController?.selectedIndex = 0
        let navController = tabBarController?.viewControllers?[0] as! UINavigationController
        let controller = navController.viewControllers[0] as! TracksViewController
        controller.navigationBarSetup()
        navigationController?.popViewController(animated: false)
    }
}

extension PlaylistViewController: OpenPlayerProtocol {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var destinationViewController = setup(playlist: dataSource.playlist, index: indexPath.row)
        destinationViewController.model?.playListItem = dataSource.playlist.playlistItem(at: indexPath.row)
        navigationController?.pushViewController(destinationViewController, animated: false)
    }
}


// MARK: - UICollectionViewDelegate
extension PlaylistViewController: UICollectionViewDelegate {
    
}
