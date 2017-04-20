//
//  PlayerViewControllerDelegate.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol PlayerViewControllerDelegate: class {
    func setNextTrack(newTrack: Bool)
    func setPreviousTrack(newTrack: Bool)
    func setNextPlaylistItem(newItem: Bool)
    func setPreviousPlaylistItem(newItem: Bool)
}
