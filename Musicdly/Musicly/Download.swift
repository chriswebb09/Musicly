//
//  Download.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol DownloadDelegate: class {
    func downloadProgressUpdated(for progress: Float, for url: String, task: URLSessionDownloadTask)
}

final class Download: Operation {
    
    weak var delegate: DownloadDelegate?
    var url: String?
    var downloadStatus: DownloadStatus = .waiting
    var isDownloading: Bool? = false
    var downloadTask: URLSessionDownloadTask?
    
    var progress: Float = 0.0 {
        didSet {
            updateProgress()
            if progress == 1 {
                downloadTask = nil
                print("File is done")
            }
        }
    }
    
    func updateProgress() {
        if let task = downloadTask,
            let url = url {
            delegate?.downloadProgressUpdated(for: progress, for: url, task: task)
        }
    }
    
    init(url: String) {
        self.url = url
    }
}
