//
//  String+Extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

extension String {
    static func constructTimeString(time: Int) -> String {
        var timeString = String(describing: time)
        var timerString = ""
        if timeString.characters.count < 2 {
            timerString = "0:0\(timeString)"
        } else if timeString.characters.count <= 2 {
            timerString = "0:\(timeString)"
        }
        return timerString
    }
}
