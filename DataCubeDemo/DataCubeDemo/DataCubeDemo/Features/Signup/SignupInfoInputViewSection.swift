//
//  SignupInfoInputViewSection.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/07/01.
//

import RxDataSources

enum SignupInfoInputViewSection {
    case title([SignupInfoInputViewSectionItem])
    case input([SignupInfoInputViewSectionItem])
}

enum SignupInfoInputViewSectionItem {
    case titleCell(TitleCellReactor)
    case inputCell(ValidationInputCellReactor)
    case marginCell(MarginCellReactor)
}

extension SignupInfoInputViewSection: SectionModelType {
    
    typealias Item = SignupInfoInputViewSectionItem
    
    var items: [Item] {
        switch self {
        case .title(let items):
            return items
        case .input(let items):
            return items
        }
    }
    
    init(original: SignupInfoInputViewSection, items: [SignupInfoInputViewSectionItem]) {
        switch original {
        case .title:
            self = .title(items)
        case .input:
            self = .input(items)
        }
    }
}
