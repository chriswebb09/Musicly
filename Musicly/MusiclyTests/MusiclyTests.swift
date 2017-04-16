//
//  MusiclyTests.swift
//  MusiclyTests
//
//  Created by Christopher Webb-Orenstein on 4/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import XCTest
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
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testForPlayer() {
        var playerViewController: PlayerViewController? = PlayerViewController()
        playerViewController?.viewDidLoad()
        playerViewController = nil
        XCTAssert(playerViewController?.playerView == nil)
    }
    
    func testForEqualizer() {
        var playerViewController: PlayerViewController? = PlayerViewController()
        var playerView: PlayerView? = PlayerView()
        
        playerViewController?.playerView = playerView
        
        playerViewController?.playButtonTapped()
//        var playerView: PlayerView? = PlayerView()
//        playerView?.configure(with: "http://is3.mzstatic.com/image/thumb/Music2/v4/a2/66/32/a2663205-663c-8301-eec7-57937c2d0878/source/60x60bb.jpg", trackName: "new")
//    
       playerViewController?.playerView = nil
        
        XCTAssert(playerViewController?.playerView?.equalView == nil)
        XCTAssert(playerViewController?.playerView?.equal == nil)
    }
}
