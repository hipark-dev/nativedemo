//
//  WelcomeViewReactor.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/27.
//

import Foundation
import ReactorKit
import RxSwift

final class WelcomeViewReactor: Reactor {
    
    enum ActionType {
        case login
        case signup
    }
    
    enum Action {
        case clickButton(ActionType)
    }
    
    enum Mutation {
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}
