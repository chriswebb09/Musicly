//
//  CellRespresentable.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/16/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol CellRepresentable {
    func cellInstance(_ tableView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}
