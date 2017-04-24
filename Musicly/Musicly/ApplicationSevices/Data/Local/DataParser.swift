import Foundation

final class DataParser {
    
    static func parseDataForTrack(json: JSON?) -> Track? {
        guard let json = json else { return nil }
        return Track(json: json)
    }
    
    static func parseDataForTracks(json: JSON?) -> [Track]? {
        guard let json = json else { return nil }
        let tracks: [Track]? = [Track]()
        if let tracksJSON = json["results"] as? [[String : Any]?]? {
            if let tracksJSON = tracksJSON {
                for trackJSON in tracksJSON {
                    guard let trackJSON = trackJSON else { return nil }
                    if let track = parseDataForTrack(json: trackJSON) {
                        guard var tracks = tracks else { return nil }
                        tracks.append(track)
                    }
                }
            }
        }
        return tracks
    }
}
