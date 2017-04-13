//
//  DownloadDelegate.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/13/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol DownloadDelegate: class {
    func downloadProgressUpdated(for progress: Float, for url: String, task: URLSessionDownloadTask)
}
