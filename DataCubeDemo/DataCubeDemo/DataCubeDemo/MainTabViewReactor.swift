//
//  TabViewReactor.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/15.
//

import Foundation
import ReactorKit

class MainTabViewReactor: Reactor {
    
    enum Action {
        case tab(MainTab)
    }
    
    enum Mutation {
        case changeView(MainTab)
    }
    
    struct State {
        var currentTab: MainTab = .top
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .tab(index):
            return .just(.changeView(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
        case .changeView(let selectTab):
            newState.currentTab = selectTab
        }
        
        return newState
    }
}
