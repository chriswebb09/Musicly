//
//  TrackListModel+CoreDataProperties.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData


extension TrackListModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackListModel> {
        return NSFetchRequest<TrackListModel>(entityName: "TrackListModel")
    }

    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var playlistID: String?
    @NSManaged public var playlistName: String?
    @NSManaged public var trackCount: Int16
    @NSManaged public var tracklist: NSSet?

}

// MARK: Generated accessors for tracklist
extension TrackListModel {

    @objc(addTracklistObject:)
    @NSManaged public func addToTracklist(_ value: TrackModel)

    @objc(removeTracklistObject:)
    @NSManaged public func removeFromTracklist(_ value: TrackModel)

    @objc(addTracklist:)
    @NSManaged public func addToTracklist(_ values: NSSet)

    @objc(removeTracklist:)
    @NSManaged public func removeFromTracklist(_ values: NSSet)

}
