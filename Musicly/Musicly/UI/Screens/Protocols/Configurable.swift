//
//  Configurable.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/16/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol Configurable {
    
    associatedtype T
    var model: T? { get set }
    func configureWithModel(_: T)
    
}
