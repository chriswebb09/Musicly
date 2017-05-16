import Foundation

protocol PlaylistCreatorDelegate: class {
    func userDidEnterPlaylistName(name: String)
}

enum PlaylistCreatorState {
    case enabled, hidden
}
