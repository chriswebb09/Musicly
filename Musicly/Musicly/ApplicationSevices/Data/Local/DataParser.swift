import Foundation

final class DataParser {
    
    static func parseDataForTrack(json: JSON?) -> iTrack? {
        guard let json = json else { return nil }
        if let track = iTrack(json: json) {
            return track
        }
        return nil
    }
    
    static func parseDataForTracks(json: JSON?) -> [iTrack]? {
        guard let json = json else { return nil }
        let tracks: [iTrack]? = [iTrack]()
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
