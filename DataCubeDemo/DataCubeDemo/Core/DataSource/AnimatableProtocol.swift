//
//  AnimatableProtocol.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import RxSwift
import RxCocoa
import RxDataSources

protocol AnimatableBaseCellModelProtocol: BaseCellModelProtocol, IdentifiableType, Equatable {
}

class AnimatableBaseCellModel: AnimatableBaseCellModelProtocol {
    var cellIdentifier: UITableViewCell.Type {
        BaseCell.self
    }
    
    typealias Identity = String
    let identity: String
    
    init(identity: String) {
        self.identity = identity
    }
    
    /// Should be override func if needed
    static func == (lhs: AnimatableBaseCellModel, rhs: AnimatableBaseCellModel) -> Bool {
        false
    }
}
