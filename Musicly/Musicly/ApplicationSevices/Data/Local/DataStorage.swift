//
//  DataStorage.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class LocalStorageManager {
    
    static func localFilePathForUrl(_ previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        let fullPath = documentsPath.appendingPathComponent((URL(string: previewUrl)?.lastPathComponent)!)
        return URL(fileURLWithPath: fullPath)
    }
    
    static func localFileExistsForImage(_ track: iTrack) -> Bool {
        if let localUrl = LocalStorageManager.localFilePathForUrl(track.previewUrl) {
            var isDir : ObjCBool = false
            return FileManager.default.fileExists(atPath: localUrl.path , isDirectory: &isDir)
        }
        return false
    }
}
