//
//  Player.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/26/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import AVFoundation

let audioCache = NSCache<NSString, AVURLAsset>()

final class TrackPlayer: NSObject, AVAssetResourceLoaderDelegate {
    
    var url: URL
    
    weak var delegate: TrackPlayerDelegate?
    
    lazy var asset: AVURLAsset = {
        var asset: AVURLAsset = AVURLAsset(url: self.url)
        asset.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
        asset.addObserver(self, forKeyPath: "duration", options: .new, context: nil)
        return asset
    }()
    
    lazy var player: AVPlayer = {
        var player: AVPlayer = AVPlayer(playerItem: self.playerItem)
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        print("Player")
        player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        return player
    }()
    
    lazy var playerItem: AVPlayerItem = {
        var playerItem: AVPlayerItem = AVPlayerItem(asset: self.asset)
        return playerItem
    }()
    
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var timeObserver: Any?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        player.removeObserver(self, forKeyPath: "status")
        if let timeObserverToken = timeObserver {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserver = nil
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            print("Change at keyPath = \(keyPath) for \(object)")
            print(player.status.rawValue)
        }
        
        if keyPath == "duration" {
            print("Change at keyPath = \(keyPath) for \(object)")
            print(asset.duration)
        }
        
        if keyPath == "playbackBufferEmpty" {
            
            print("Change at keyPath = \(keyPath) for \(object)")
        }
        
        if keyPath == "playbackLikelyToKeepUp" {
            print("Change at keyPath = \(keyPath) for \(object)")
        }
    }
    
    init(url: URL) {
        self.url = url
        super.init()
        self.getTrackDuration()
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
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
    
    func playerItemDidReachEnd(notification: NSNotification) {
        delegate?.trackFinishedPlaying()
        player.seek(to: kCMTimeZero)
        player.pause()
    }
    
    func removePlayTimeObserver() {
        guard let test = timeObserver else { return }
        player.removeTimeObserver(test)
    }
}
