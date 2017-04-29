//
//  Player.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/26/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import AVFoundation

final class TrackPlayer: NSObject, AVAssetResourceLoaderDelegate {
    
    var url: URL
    
    lazy var asset: AVURLAsset = {
        var asset: AVURLAsset = AVURLAsset(url: self.url)
        asset.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
        return asset
    }()
    
    lazy var player: AVPlayer = {
        var player: AVPlayer = AVPlayer(playerItem: self.playerItem)
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        return player
    }()
    
    lazy var playerItem: AVPlayerItem = {
        var playerItem: AVPlayerItem = AVPlayerItem(asset: self.asset)
        return playerItem
    }()
    
    init(url: URL) {
        self.url = url
    }
    
    func setUrlFromString(urlString: String?) {
        guard let urlString = urlString else { return }
        self.url = URL(string: urlString)!
    }
    
    func setUrl(url: URL) {
        self.url = url
    }
    
    func getTrackDuration(completion: @escaping (_ stringTime: String, _ timeValue: Float64) -> Void) {
        asset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) {
            let audioDuration = self.asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            let minutes = Int(audioDurationSeconds / 60)
            let rem = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 60))
            DispatchQueue.main.async {
                completion("\(minutes):\(rem + 2)", audioDurationSeconds)
            }
        }
    }
}
