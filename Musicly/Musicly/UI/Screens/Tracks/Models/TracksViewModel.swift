//
//  TracksViewModel.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class TracksViewModel {
    
    var stateLabelsHidden: Bool?
    var playlist: Playlist?
    
    func toggle(to: Bool) {
        stateLabelsHidden = to
    }
    
    func rowTimeForIndex(indexPath: IndexPath) -> Double {
        let rowTime =  indexPath.row > 10 ? (Double(indexPath.row % 10)) / CollectionViewConstants.rowTimeDivider : (Double(indexPath.row)) / CollectionViewConstants.rowTimeDivider
        return rowTime
    }
}
