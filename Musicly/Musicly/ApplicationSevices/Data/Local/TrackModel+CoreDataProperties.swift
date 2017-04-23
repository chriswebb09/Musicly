//
//  TrackModel+CoreDataProperties.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData


extension TrackModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackModel> {
        return NSFetchRequest<TrackModel>(entityName: "TrackModel")
    }

    @NSManaged public var artistId: String?
    @NSManaged public var artistName: String?
    @NSManaged public var artworkUrl: String?
    @NSManaged public var collectionName: String?
    @NSManaged public var dataAdded: NSDate?
    @NSManaged public var downloaded: Bool
    @NSManaged public var playlistId: String?
    @NSManaged public var position: Int16
    @NSManaged public var previewUrl: String?
    @NSManaged public var thumbsDown: Bool
    @NSManaged public var thumbsUp: Bool
    @NSManaged public var trackName: String?
    @NSManaged public var track: TrackListModel?

}
