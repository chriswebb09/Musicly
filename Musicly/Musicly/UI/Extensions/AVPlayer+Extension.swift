//
//  AVPlayer+Extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/14/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    func setupWithItem(itemUrl: URL) {
        let playerItem = AVPlayerItem(url: itemUrl)
        self.replaceCurrentItem(with: playerItem)
        rate = PlayerAttributes.playerRate
        pause()
    }
    
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
    
}
