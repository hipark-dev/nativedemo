//
//  MarginCellReactor.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/07/01.
//

import ReactorKit

class MarginCellReactor: Reactor {

    enum Action { }
    enum Mutation { }
    
    struct State {
        var cellModel: MarginCellModel
    }
    
    let initialState: State
    
    init(model: MarginCellModel) {
        self.initialState = State(cellModel: model)
    }
    
}
