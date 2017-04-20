//
//  TracksViewControllerDelegate.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol TracksViewControllerDelegate: class {
    func getPrivousTrack(iTrack: iTrack)
    func getNextTrack(iTrack: iTrack)
    func getNextPlaylistItem(item: PlaylistItem)
    func getPreviousPlaylistItem(item: PlaylistItem)
}
