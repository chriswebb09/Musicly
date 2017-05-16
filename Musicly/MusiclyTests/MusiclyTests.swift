import XCTest
import AVFoundation
@testable import Musicly

class MusiclyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDataStore() {
        let realmClient = RealmClient()
        let dataStore = iTrackDataStore(realmClient: realmClient)
        dataStore.setSearch(string: "new")
        let expect = expectation(description: "Data store calls APIClient to access server data and returns iTrack data array.")
        dataStore.searchForTracks { playlist, error in
            XCTAssert(playlist?.itemCount == 50)
            expect.fulfill()
        }
        waitForExpectations(timeout: 4) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testRemoveAllItemsFromPlaylist() {
        var realmClient = RealmClient()
        let dataStore = iTrackDataStore(realmClient: realmClient)
        dataStore.setSearch(string: "new")
        let expect = expectation(description: "Removes all items in array.")
        dataStore.searchForTracks { playlist, error in
            var testList = playlist
            testList?.removeAll()
            XCTAssert(testList?.itemCount == 0)
            expect.fulfill()
        }
        waitForExpectations(timeout: 4) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testSearchBarActive() {
        let controller = TracksViewController()
        controller.setSearchBarActive()
        XCTAssertTrue(controller.searchBarActive)
    }
    
    func testForSearchController() {
        let controller = TracksViewController()
        let realmClient = RealmClient()
        let store = iTrackDataStore(realmClient: realmClient)
        let dataSource = ListControllerDataSource()
        dataSource.store = store
        controller.dataSource = dataSource
        controller.viewDidLoad()
        XCTAssertNotNil(controller.searchController)
    }
    
    func testSearchForBar() {
        let controller = TracksViewController()
        let realmClient = RealmClient()
        let store = iTrackDataStore(realmClient: realmClient)
        let dataSource = ListControllerDataSource()
        dataSource.store = store
        controller.dataSource = dataSource
        controller.viewDidLoad()
        XCTAssertNotNil(controller.searchController.searchBar)
    }
    
    func testForSearchText() {
        let controller = TracksViewController()
        let realmClient = RealmClient()
        let store = iTrackDataStore(realmClient: realmClient)
        let dataSource = ListControllerDataSource()
        dataSource.store = store
        controller.dataSource = dataSource
        controller.viewDidLoad()
        controller.searchController.searchBar.text = "Hi"
        controller.searchBarTextDidBeginEditing(searchBar: controller.searchController.searchBar)
        XCTAssertNotNil(controller.searchController.searchBar.text)
    }
    
    
    func testSearchOnTextChange() {
        let controller = TracksViewController()
        let realmClient = RealmClient()
        let store = iTrackDataStore(realmClient: realmClient)
        let dataSource = ListControllerDataSource()
        dataSource.store = store
        controller.dataSource = dataSource
        controller.viewDidLoad()
        guard let navController = controller.navigationController else { return }
        controller.searchOnTextChange(text: "hello", store: dataSource.store, navController: navController)
        XCTAssert(controller.dataSource.store.searchTerm == "hello")

    }
}

