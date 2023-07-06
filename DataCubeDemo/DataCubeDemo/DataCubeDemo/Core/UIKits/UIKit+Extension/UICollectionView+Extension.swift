//
//  UICollectionView+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa

extension UICollectionReusableView: ReusableView {}
extension UICollectionView {
    func register<T: UICollectionReusableView>(_ name: T.Type) {
        let cellName = String(describing: T.self)
        let nib = UINib(nibName: cellName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: String(describing: cellName))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: name))")
        }
        return cell
    }
    
    public func register<T: UICollectionViewCell>(with className: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    public func register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, with className: T.Type) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }
}

extension UICollectionView {
    func isIndexPathAvailable(_ indexPath: IndexPath) -> Bool {
        guard dataSource != nil,
            indexPath.section < numberOfSections,
            indexPath.item < numberOfItems(inSection: indexPath.section) else {
                return false
        }
        
        return true
    }
    func scrollToItemIfAvailable(_ indexPath: IndexPath, _ animated: Bool = true) {
        guard isIndexPathAvailable(indexPath) else {
            return
        }
        DispatchQueue.main.async {
            self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        }
    }
}

extension UICollectionView {
    // Dequeue reusable UITableViewCell
    func dequeueBaseCell<T: UICollectionViewCell>(class name: T.Type, for indexPath: IndexPath, configure value: BaseCollectionCellModelProtocol) -> T {
        guard let baseCell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? BaseCollectionCell else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name))")
        }
        baseCell.configureWith(value: value)
        
        guard let cell = baseCell as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name))")
        }
        return cell
    }
}

extension Reactive where Base: UICollectionView {
    func modelAndItemSelected<T>(_ modelType: T.Type) -> Observable<(T, IndexPath)> {
        Observable.zip(base.rx.modelSelected(modelType), base.rx.itemSelected)
    }
}
