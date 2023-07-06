//
//  LabelCellReactor.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/30.
//

import ReactorKit

class LabelCellReactor: Reactor {
    
    typealias Action = NoAction
    
    let initialState: LabelCellModel
    
    init(state: LabelCellModel) {
        self.initialState = state
    }
}
