//
//  BaseCellModel.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import RxDataSources

protocol BaseCellModelProtocol {
    var cellIdentifier: UITableViewCell.Type { get }
}

class BaseCellModel: BaseCellModelProtocol {
    var cellIdentifier: UITableViewCell.Type {
        BaseCell.self
    }

    private var internalIdentifier: String = ""
    var identifier: String {
        get {
            guard internalIdentifier.isEmpty == false else {
                internalIdentifier = String(describing: cellIdentifier) + "/" + UUID().uuidString
                return internalIdentifier
            }
            return internalIdentifier
        }
        set {
            internalIdentifier = newValue
        }
    }
}

class BaseCollectionCellModel: BaseCollectionCellModelProtocol {
    var cellIdentifier: UICollectionViewCell.Type {
        BaseCollectionCell.self
    }
}
extension BaseCellModel: HasLet, Equatable {}
extension BaseCellModel {
    static func == (lhs: BaseCellModel, rhs: BaseCellModel) -> Bool {
        guard lhs.identifier.isEmpty == false, rhs.identifier.isEmpty == false else { return false }
        return lhs.identifier == rhs.identifier
    }
    
    @objc @discardableResult func identifier(_ identifier: String) -> Self {
        self.identifier = identifier
        return self
    }
    
    @discardableResult
    func identifier<T>(_ identifier: T) -> Self where T: RawRepresentable, T.RawValue == String {
        self.identifier = identifier.rawValue
        return self
    }
}

extension BaseCellModel: IdentifiableType {
    typealias Identity = String
    
    var identity: String { identifier }
}
