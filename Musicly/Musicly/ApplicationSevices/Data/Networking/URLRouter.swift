//
//  URLRouter.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

enum URLRouter {
    
    case base, path
    
    var url: String {
        switch self {
        case .base:
            return "https://itunes.apple.com"
        case .path:
            return "/search?media=music&entity=song&term="
        }
    }
}
