//
//  Filter.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

struct Filter {
    static func filteredBy(filterFrom: [iTrack], term: String) -> [iTrack] {
        let predicate = NSPredicate(format: "SELF BEGINSWITH %@", term)
        let searchDataSource = filterFrom.filter { predicate.evaluate(with: $0.trackName) }

        let sortedData = searchDataSource.sorted { $0.0.trackName?.localizedCaseInsensitiveCompare($0.1.trackName!) == ComparisonResult.orderedAscending }
        return sortedData
    }
}
