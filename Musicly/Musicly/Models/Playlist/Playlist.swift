//
//  Playlist.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/13/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

struct TrackQueue {
    
    private var tracks = [iTrack?]()
    
    var isEmpty: Bool {
        return count == 0
    }
    
    var count: Int {
        return tracks.count - head
    }
    
    private var head = 0
    
    mutating func enqueue(_ track: iTrack) {
        tracks.append(track)
    }
    
    mutating func dequeue() -> iTrack? {
        guard head < tracks.count, let track = tracks[head] else { return nil }
        tracks[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(tracks.count)
        if tracks.count > 50 && percentage > 0.25 {
            tracks.removeFirst(head)
            head = 0
        }
        
        return track
    }
}

class PlaylistItem {
    var playListID: String? = ""
    var identifier: String? = ""
    var track: iTrack?
    var next: PlaylistItem? = nil
    weak var previous: PlaylistItem? = nil
    
    public init(item: iTrack?) {
        print("Creating track \(item)")
        self.track = item
    }
}

extension PlaylistItem: Equatable {
    static func ==(lhs: PlaylistItem, rhs: PlaylistItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class Playlist {
    
    private var head: PlaylistItem?
    
    var isEmpty: Bool {
        return head == nil
    }
    
    private var first: PlaylistItem? {
        return head
    }
    
    var tail: PlaylistItem? {
        guard last != nil else {
            return nil
        }
        return last
    }
    
    private var last: PlaylistItem? {
        if var track = head {
            while case let next? = track.next {
                track = next
            }
            return track
        } else {
            return nil
        }
    }
    
    var itemCount: Int = 0
    
    func append(value: iTrack?) {
        let newNode: PlaylistItem? = PlaylistItem(item: value!)
        itemCount += 1
        if let lastNode = tail {
            newNode?.previous = lastNode
            lastNode.next = newNode
        } else if head == nil {
            head = newNode
        }
    }
    
    func playlistItem(at index: Int) -> PlaylistItem? {
        
        if index >= 0 {
            var trackItem = head
            
            print(trackItem?.next?.track?.trackName ?? "no track item")
            var i = index
            while let trackAt = trackItem, trackItem != nil {
                print("getting node \(String(describing: trackAt.next?.track?.trackName))")
                if i == 0 {
                    print(" return \(String(describing: trackItem?.track?.trackName))")
                    return trackAt
                }
                i -= 1
                print("getting node \(String(describing: trackAt.next?.track?.trackName))")
                trackItem = trackAt.next
            }
        }
        return nil
    }
    
    public func reverse() {
        var node = head
        while let currentNode = node {
            node = currentNode.next
            swap(&currentNode.next, &currentNode.previous)
            head = currentNode
        }
    }
    
    public func removeFromPlaylist(for playlistItem: PlaylistItem?) -> iTrack {
        let previous = playlistItem?.previous
        let next = playlistItem?.next
        
        if let previous = previous {
            previous.next = next
        } else {
            head = next
        }
        next?.previous = previous
        
        playlistItem?.previous = nil
        playlistItem?.next = nil
        return playlistItem!.track!
    }
    
    public func removeAll() {
        head = nil
        itemCount = 0
    }
    
    func contains(playlistItem item: PlaylistItem) -> Bool {
        guard let currentTrack = head else { return false }
        while currentTrack != item && currentTrack.next != nil {
            guard let currentTrack = currentTrack.next else { return false }
            if currentTrack == item {
                return true
            }
        }
        return false
    }
    
    func playlistItem(with trackName: String, for artistName: String) -> PlaylistItem? {
        guard let currentTrack = head else { return nil }
        
        while currentTrack.track?.trackName != trackName  && currentTrack.track?.artistName != artistName {
            guard let currentTrack = currentTrack.next else { return nil }
            print("checked track at \(currentTrack.track?.trackName)")
            if currentTrack.track?.trackName == trackName {
                print("Found track: \(currentTrack.track?.trackName)")
                return currentTrack
            }
        }
        return nil
    }
}

extension PlaylistItem: CustomStringConvertible {
    public var description: String {
        get {
            return "Node(\(identifier))"
        }
    }
}


