//
//  MusiclyAPISpec.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Quick
import Nimble
import UIKit
@testable
import Musicly
import Realm
import RealmSwift


class MusiclyAPISpec: QuickSpec {
    
    override func spec() {
        
        describe("requests") {
            beforeSuite {
                // Implement
            }
            
            afterSuite {
                // Implement
            }
            
            it("returns some data") {
                let store = iTrackDataStore()
                store.setSearch(string: "New")
                store.searchForTracks { tracks, errors in
                    print(tracks)
                }
                expect(store.tracks.count).to(beTruthy())
            }
            
        }
    }
}
