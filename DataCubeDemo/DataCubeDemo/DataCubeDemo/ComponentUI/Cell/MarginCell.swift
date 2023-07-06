//
//  MarginCell.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import ReactorKit

class MarginCell: BaseCell, View {
    
    typealias Reactor = MarginCellReactor
    
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    
    func bind(reactor: MarginCellReactor) {
        let cellModel = reactor.currentState.cellModel
        heightConstraint.constant = cellModel.height
    }
}
