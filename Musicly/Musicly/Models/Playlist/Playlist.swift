//
//  Playlist.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/13/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class Playlist {
    
    private var head: PlaylistItem?
    var itemCount: Int = 0
    
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
            var i = index
            while let trackAt = trackItem, trackItem != nil {
                if i == 0 {
                    return trackAt
                }
                i -= 1
                trackItem = trackAt.next
            }
        }
        return nil
    }
    
    func reverse() {
        var track = head
        while let currentTrack = track {
            track = currentTrack.next
            swap(&currentTrack.next, &currentTrack.previous)
            head = currentTrack
        }
    }
    
    func removeFromPlaylist(for playlistItem: PlaylistItem?) -> iTrack {
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
    
    func removeAll() {
        head = nil
        itemCount = 0
    }
    
    func contains(playlistItem item: PlaylistItem) -> Bool {
        guard let currentTrack = head else { return false }
        while currentTrack != item && currentTrack.next != nil {
            print(currentTrack.track?.trackName)
            print(item.track?.trackName)
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
     
            if currentTrack.track?.trackName == trackName {
                
                return currentTrack
            }
        }
        return nil
    }
}




