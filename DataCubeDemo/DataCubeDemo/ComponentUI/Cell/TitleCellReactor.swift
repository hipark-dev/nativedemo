//
//  TitleCellReactor.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/07/01.
//

import ReactorKit

class TitleCellReactor: Reactor {
    
    enum Action { }
    enum Mutation { }
    
    struct State {
        var cellModel: TitleCellModel
    }
    
    let initialState: State
    
    init(model: TitleCellModel) {
        self.initialState = State(cellModel: model)
    }
}
