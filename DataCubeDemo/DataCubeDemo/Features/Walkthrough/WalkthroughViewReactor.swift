//
//  WalkthroughViewReactor.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/16.
//

import Foundation
import ReactorKit

final class WalkthroughViewReactor: Reactor {

    let initialState = State()
    let pageWidth: CGFloat = 358.0
    
    enum Action {
        case next
        case swipeView
    }
    
    enum Mutation {
        case next
        case changePageIndex(index: Int)
    }
    
    struct State {
        var imageNames: [String] = ["welcome", "FlightPass", "GenericPass"]
        var currentPageIndex: Int = .zero
        var nextButtonState: ButtonState = .disable
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .next:
            return .just(Mutation.next)
        case .swipeView:
            return .just(Mutation.changePageIndex(index: 0))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .next:
            break
        case let .changePageIndex(index):
            state.currentPageIndex = index
            state.nextButtonState = index == state.imageNames.count - 1 ? .enable : .disable
        }
        return state
    }
    
}

extension WalkthroughViewReactor {
    func page(_ offset: CGPoint) -> Int {
        return Int(offset.x / pageWidth)
    }
}
