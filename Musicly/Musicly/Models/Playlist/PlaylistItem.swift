import UIKit
import Realm
import RealmSwift

final class PlaylistItem: Object {
    var track: Track?
    var next: PlaylistItem?
    weak var previous: PlaylistItem?
}

