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
    func trackDurationCalculated(stringTime: String, timeValue: Float64)
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
    
    var timeObserver: Any?
    
    init(url: URL) {
        self.url = url
        super.init()
        self.getTrackDuration()
    }
    
    func setUrl(from string: String?) {
        guard let urlString = string else { return }
        self.url = URL(string: urlString)!
        getTrackDuration()
    }
    
    func setUrl(with url: URL) {
        self.url = url
        getTrackDuration()
    }
    
    func play() {
        player.playImmediately(atRate: 1)
    }
    
    func getTrackDuration() {
        asset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) {
            let audioDuration = self.asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            let minutes = Int(audioDurationSeconds / 60)
            let rem = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 60))
            self.delegate?.trackDurationCalculated(stringTime: "\(minutes):\(rem + 2)", timeValue: audioDurationSeconds)
        }
    }
    
    func observePlayTime() {
        if self.delegate == nil {
            print("Delegate is not set")
            return
        }
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 30), queue: .main) { time in
            guard let currentItem = self.player.currentItem else { return }
            let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(currentItem.duration)
            let time = fraction / 450
            self.delegate?.updateProgress(progress: time)
        }
    }
    
    func removePlayTimeObserver() {
        guard let test = timeObserver else { return }
        player.removeTimeObserver(test)
    }
}
