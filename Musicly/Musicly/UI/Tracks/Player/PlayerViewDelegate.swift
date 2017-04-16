//
//  PlayerViewDelegate.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/13/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol PlayerViewDelegate: class {
    func playButtonTapped()
    func pauseButtonTapped()
    func thumbsUpTapped()
    func thumbsDownTapped()
    func resetPlayerAndSong()
}
