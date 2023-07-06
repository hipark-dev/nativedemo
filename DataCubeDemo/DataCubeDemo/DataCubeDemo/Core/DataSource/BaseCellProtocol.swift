//
//  BaseCellProtocol.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import ReactorKit

protocol BaseCellProtocol {
    associatedtype Value
    func configureWith(value: Value)
    
    var disposeBag: DisposeBag { get }
}

protocol BaseCollectionCellModelProtocol {
    var cellIdentifier: UICollectionViewCell.Type { get }
}
// MARK: - BaseCell
class BaseCell: UITableViewCell, BaseCellProtocol, Reusable {
    
    typealias Value = BaseCellModelProtocol
    var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    /// Should be override func if needed
    func configureWith(value: BaseCellModelProtocol) {
    }
    deinit {
        disposeBag = DisposeBag()
    }
}
// MARK: - BaseCell
class BaseCollectionCell: UICollectionViewCell, BaseCellProtocol {
    typealias Value = BaseCollectionCellModelProtocol
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    /// Should be override func if needed
    func configureWith(value: BaseCollectionCellModelProtocol) {
    }
}
