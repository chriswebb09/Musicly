//
//  Player.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/26/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import AVFoundation

protocol TrackPlayerDelegate: class {
    func updateProgress(progress: Double)
}

let audioCache = NSCache<NSString, AVURLAsset>()

final class TrackPlayer: NSObject, AVAssetResourceLoaderDelegate {
    
    var url: URL
    
    weak var delegate: TrackPlayerDelegate?
    
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
    
    var test: Any?
    
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
    
    func play() {
        player.playImmediately(atRate: 1)
    }
    
    func getTrackDuration(completion: @escaping (_ stringTime: String, _ timeValue: Float64) -> Void) {
        asset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) {
            print("track duration")
            let audioDuration = self.asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            print("audio")
            let minutes = Int(audioDurationSeconds / 60)
            let rem = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 60))
            DispatchQueue.main.async {
                print("completion")
                completion("\(minutes):\(rem + 2)", audioDurationSeconds)
            }
        }
    }
    
    func observePlayTime() {
        print("observing")
        test = player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 30), queue: .main) { time in
            guard let currentItem = self.player.currentItem else { return }
            let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(currentItem.duration)
            let time = fraction / 450
            self.delegate?.updateProgress(progress: time)
            //self.playerView.updateProgressBar(value: time)
        }
    }
    
    func removePlayTimeObserver() {
        guard let test = test else { return }
        player.removeTimeObserver(test)
    }
}
