//
//  MusiclyTests.swift
//  MusiclyTests
//
//  Created by Christopher Webb-Orenstein on 4/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import XCTest
import AVFoundation
@testable import Musicly

class MusiclyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        let splashVC = SplashViewController()
        splashVC.viewDidLoad()
        // This is an example of a performance test case.
        self.measure {
            splashVC.splashView.zoomAnimation()
            // Put the code you want to measure the time of here.
        }
    }
    
    func testForPlayerViewDeallocation() {
        var playerViewController: PlayerViewController? = PlayerViewController()
        playerViewController?.viewDidLoad()
        playerViewController = nil
        XCTAssert(playerViewController?.playerView == nil)
    }
    
    func testForPlayer() {
        let playerViewController: PlayerViewController? = PlayerViewController()
        playerViewController?.viewDidLoad()
        playerViewController?.playButtonTapped()
        playerViewController?.player = AVPlayer()
        XCTAssert(playerViewController?.player != nil)
    }
    
    func testDataStore() {
        
        let dataSource = iTrackDataStore(searchTerm: "new")
        let expect = expectation(description: "Data store calls api and returns iTrack data array.")
        
        dataSource.searchForTracks { tracks, error in
            XCTAssert(tracks?.count == 49)
            expect.fulfill()
        }

        waitForExpectations(timeout: 4) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
