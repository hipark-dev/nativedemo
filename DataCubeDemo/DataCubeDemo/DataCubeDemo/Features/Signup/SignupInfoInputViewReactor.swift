//
//  SignupInfoInputViewReactor.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/07/01.
//

import ReactorKit

final class SignupInfoInputViewReactor: Reactor {
    
    enum Action {
        case fullButtonTap
    }
    
    enum Mutation {
        case next
    }
    
    struct State {
        var sections: [SignupInfoInputViewSection]
    }
    
    let initialState: State
    
    init() {
        initialState = State(sections: SignupInfoInputViewReactor.makeSections())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fullButtonTap:
            return Observable<Mutation>.just(.next)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        let state = state
        switch mutation {
        case .next:
            Logger.debug("가입하기 버튼!!!!!!!!!!!!!!")
            break
        }
        return state
    }
}

extension SignupInfoInputViewReactor {
    private static func makeSections() -> [SignupInfoInputViewSection] {
        
//        let titleCellItem = SignupInfoInputViewSectionItem.titleCell(.init(model: TitleCellModel("회원가입", .setting)))
//        let marginCellItem = SignupInfoInputViewSectionItem.marginCell(.init(model: MarginCellModel(40)))
//        let titleSection = SignupInfoInputViewSection.title([titleCellItem, marginCellItem])
//
//        return [titleSection]
        
        var sections: [SignupInfoInputViewSection] = []
        
        let titleItems: [SignupInfoInputViewSectionItem] = [
            SignupInfoInputViewSectionItem.titleCell(.init(model: TitleCellModel("회원가입", .setting))),
            SignupInfoInputViewSectionItem.marginCell(.init(model: MarginCellModel(40)))
        ]
        
        let inputItems: [SignupInfoInputViewSectionItem] = [
            SignupInfoInputViewSectionItem.marginCell(.init(model: MarginCellModel(40))),
            SignupInfoInputViewSectionItem.titleCell(.init(model: TitleCellModel("입력영역", .setting))),
            SignupInfoInputViewSectionItem.marginCell(.init(model: MarginCellModel(40)))
        ]
        
        sections.append(contentsOf: [
            .title(titleItems),
            .input(inputItems)
        ])
        return sections
    }
}
