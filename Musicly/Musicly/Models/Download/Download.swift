//
//  Download.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol DownloadDelegate: class {
    func downloadProgressUpdated(for progress: Float)
}

enum DownloadStatus {
    case waiting, downloading, finished, cancelled
}

final class Download {
    
    weak var delegate: DownloadDelegate?
    
    var url: String?
    var downloadTask: URLSessionDownloadTask?
    
    var progress: Float = 0.0 {
        didSet {
            updateProgress()
        }
    }
    
    // Gives float for download progress - for delegate
    
    private func updateProgress() {
        delegate?.downloadProgressUpdated(for: progress)
    }
    
    init(url: String) {
        self.url = url
    }
}

extension Download {
    
    func getDownloadURL() -> URL? {
        if let url = self.url {
            return URL(string: url)
        }
        return nil
    }
    
}
