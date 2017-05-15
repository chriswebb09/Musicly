//
//  EmptyViewProtocol.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/14/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

 protocol EmptyViewProtocol {
    func setupEmptyView(emptyView: EmptyView, for view: UIView)
 }

 extension EmptyViewProtocol {
    func setupEmptyView(emptyView: EmptyView, for view: UIView) {
        view.addSubview(emptyView)
        emptyView.layoutSubviews()
        emptyView.frame = view.frame
    }
 }
