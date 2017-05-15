import UIKit

struct PlayerViewModel {
    var thumbs: Thumbs {
        didSet {
            thumbsUpImage = thumbs == .up ? #imageLiteral(resourceName: "thumbsupiconorange") : #imageLiteral(resourceName: "thumbsupblue")
            thumbsDownImage = thumbs == .down ? #imageLiteral(resourceName: "thumbsdownorange") : #imageLiteral(resourceName: "thumbsdownblue")
        }
    }
    
    var defaultTimeString: String {
        return "0:00"
    }
    
    var currentPlayTimeColor: UIColor = .orange
    var totalPlayTimeColor: UIColor
    var progress: Float
    var playState: FileState {
        didSet {
            currentPlayTimeColor = playState == .done ? .white : .orange
            totalPlayTimeColor = playState == .done ? .orange : .white
            print(playState)
        }
    }
    var trackName: String
    var thumbsUpImage: UIImage
    var thumbsDownImage: UIImage
    var time: Int
    var totalTime: Int
    var totalTimeString: String
    var artworkUrlString: String {
        didSet {
            self.artworkUrl = URL(string: artworkUrlString)
        }
    }
    
    var artworkUrl: URL?
    
    init(track: Track, playState: FileState) {
        self.playState = playState
        self.currentPlayTimeColor = .orange
        self.totalPlayTimeColor = .white
        self.time = 0
        self.progress = 0
        self.totalTimeString = ""
        self.totalTime = 0
        self.thumbs = .none
        self.thumbsDownImage = UIImage()
        self.thumbsUpImage = UIImage()
        self.artworkUrlString = track.artworkUrl
        self.trackName = track.trackName
    }
    
    
    mutating func resetProgress() {
        self.progress = 0 
    }
    
    mutating func resetTime() {
        self.time = 0 
    }
}
