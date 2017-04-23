//
//  APIClient.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

// MARK: - JSON type

typealias JSON = [String: Any]

@objc(iTunesAPIClient)
final class iTunesAPIClient: NSObject {
    
    var activeDownloads: [String: Download]?
    weak var defaultSession: URLSession? = URLSession(configuration: .default)
    
    // MARK: - Main session used
    
    weak var downloadsSession : URLSession? {
        get {
            let config = URLSessionConfiguration.background(withIdentifier: "background")
            weak var queue: OperationQueue? = OperationQueue()
            return URLSession(configuration: config, delegate: self, delegateQueue: queue)
        }
    }
    
    func setup() {
        activeDownloads = [String: Download]()
    }
    
    // MARK: - Main search functionality
    
    static func search(for query: String, completion: @escaping (_ responseObject: JSON?, _ error: Error?) -> Void) {
        if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(encodedQuery)") {
            self.downloadData(url: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    do {
                        let responseObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        DispatchQueue.main.async {
                            completion(responseObject, nil)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Transitory session
    
    internal static func downloadData(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        weak var downloadSession : URLSession? {
            get {
                let config = URLSessionConfiguration.ephemeral
                return URLSession(configuration: config)
            }
        }
        
        let task: URLSessionDataTask? = downloadSession?.dataTask(with: URLRequest(url: url)) { data, response, error in
            completion(data, response, error)
            downloadSession?.invalidateAndCancel()
        }
        
        task?.resume()
        
    }
}

// MARK: - URLSessionDownloadDelegate

extension iTunesAPIClient: URLSessionDownloadDelegate {
    
    func downloadTrackPreview(for download: Download?) {
        if let download = download,
            let urlString = download.url,
            let url = URL(string: urlString) {
            download.isDownloading = true
            download.downloadStatus = .downloading
            activeDownloads?[urlString] = download
            download.downloadTask = downloadsSession?.downloadTask(with: url)
            download.downloadTask?.resume()
        }
    }
    
    func startDownload(_ download: Download?) {
        if let download = download, let url = download.url {
            activeDownloads?[url] = download
            if let url = download.url {
                if URL(string: url) != nil {
                    downloadTrackPreview(for: download)
                }
            }
        }
    }
    
    // MARK: - Keeps track of download index - for collectionView
    
    func trackIndexForDownloadTask(_ tracks: [Track], _ downloadTask: URLSessionDownloadTask) -> Int? {
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            for (index, track) in tracks.enumerated() {
                if url == track.previewUrl {
                    return index
                }
            }
        }
        return nil
    }
}

// MARK: - URLSessionDelegate

extension iTunesAPIClient: URLSessionDelegate {
    
    internal func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let completionHandler = appDelegate.backgroundSessionCompletionHandler {
            appDelegate.backgroundSessionCompletionHandler = nil
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    // TODO: - Possibly unneeded
    
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads?[downloadUrl] {
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        }
    }
}

extension iTunesAPIClient {
    
    
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString {
            let destinationURL = LocalStorageManager.localFilePathForUrl(originalURL)
            let fileManager = FileManager.default
            
            do {
                if let destinationURL = destinationURL {
                    try fileManager.copyItem(at: location, to: destinationURL)
                }
            } catch let error {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads?[downloadUrl] {
            download.downloadStatus = .finished
            download.isDownloading = false
        }
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: URLSession) {
        print("Session: \(session)")
    }
}

