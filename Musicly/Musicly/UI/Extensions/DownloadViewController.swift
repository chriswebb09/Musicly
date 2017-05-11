//
//  DownloadViewController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/6/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UIViewController: DownloadDelegate {
    
    func downloadProgressUpdated(for progress: Float) {
        print(progress)
    }

    
}
