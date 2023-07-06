//
//  UITableView+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension UITableViewHeaderFooterView: ReusableView {}
extension UITableViewCell: ReusableView {}
extension UITableView {
    //  Register nib
    func register<T: UITableViewCell>(_ className: T.Type) {
        let cellName = String(describing: T.self)
        let nib = UINib(nibName: cellName, bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: cellName))
    }
    
    func register<T: UITableViewHeaderFooterView>(_ className: T.Type) {
        let cellName = String(describing: T.self)
        let nib = UINib(nibName: cellName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: cellName))
    }
    
    //
    func register<T: UITableViewCell>(with className: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(headerFooterViewWith className: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
}

extension UITableView {
    // Dequeue reusable UITableViewCell
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        return cell
    }
    func dequeueReusableOptionalCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            Logger.error("dequeueReusableOptionalCell \(name)")
            return nil
        }
        return cell
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewHeaderFooterView for \(String(describing: name))")
        }
        return headerFooterView
    }
}

extension UITableView {
    
    // Dequeue reusable UITableViewCell
    func dequeueBaseCell<T: UITableViewCell>(class name: T.Type, configure value: BaseCellModelProtocol) -> T {
        guard let baseCell = dequeueReusableCell(withIdentifier: String(describing: name)) as? BaseCell else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        baseCell.configureWith(value: value)
        guard let cell = baseCell as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        return cell
    }

    func dequeueBaseCell<T: UITableViewCell>(class name: T.Type, for indexPath: IndexPath, configure value: BaseCellModelProtocol) -> T {
        guard let baseCell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? BaseCell else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        baseCell.configureWith(value: value)
        guard let cell = baseCell as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        return cell
    }

    func dequeueOptionalBaseCell<T: UITableViewCell>(class name: T.Type, for indexPath: IndexPath, withConfigure value: BaseCellModelProtocol) -> T? {
        guard let baseCell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? BaseCell else {
            Logger.error("dequeueReusableOptionalCell \(name)")
            return nil
        }
        baseCell.configureWith(value: value)
        guard let cell = baseCell as? T else {
            Logger.error("dequeueReusableOptionalCell \(name)")
            return nil
        }
        return cell
    } 
}

extension UITableView {
    
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }
        
        return lastIndexPath == indexPath
    }
    
    var tableViewHeight: CGFloat {
        layoutIfNeeded()
        return contentSize.height
    }
    
    func isLastSection(_ section: Int) -> Bool {
        section == numberOfSections - 1
    }
    
    func applyZeroOffsetHeader() {
        if contentOffset.y < sectionHeaderHeight && contentOffset.y >= .zero {
            contentInset.top = -contentOffset.y
        } else if contentOffset.y >= sectionHeaderHeight {
            contentInset.top = -sectionHeaderHeight
        }
    }
}
