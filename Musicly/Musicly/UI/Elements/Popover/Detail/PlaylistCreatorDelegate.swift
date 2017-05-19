import Foundation

protocol PlaylistCreatorDelegate: PopDelegate {
    func userDidEnterPlaylistName(name: String)
}

enum PlaylistCreatorState {
    case enabled, hidden
}
