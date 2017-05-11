//
//  PlaylistsViewControllerDataSource.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class PlaylistsViewControllerDataSource {
    var tracklist: [TrackList] = []
    var store: iTrackDataStore!
    let buttonImage = #imageLiteral(resourceName: "blue-musicnote").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
}
