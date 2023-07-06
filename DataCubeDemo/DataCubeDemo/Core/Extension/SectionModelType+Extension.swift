//
//  SectionModelType+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import RxDataSources

protocol SectionModelType: Differentiator.SectionModelType & Identifiable {}

extension Array where Element: SectionModelType, Element.Item == BaseCellModelProtocol {
    subscript(_ value: Element) -> [BaseCellModel]? {
        filter { value == $0 }.first?.items.compactMap { $0 as? BaseCellModel }
    }
    
    func indexPath(_ sectionModel: Element, rowModel: BaseCellModel) -> IndexPath? {
        guard let section = firstIndex(of: sectionModel) else { return nil }
        guard let row = self[sectionModel]?.firstIndex(of: rowModel) else { return nil }
        return .init(row: row, section: section)
    }
    
    func indexSet( _ sectionModel: Element?) -> IndexSet? {
        guard let sectionModel = sectionModel else { return nil }
        guard let sectionIndex = firstIndex(of: sectionModel) else { return nil }
        return NSIndexSet(index: sectionIndex) as IndexSet
    }
}
extension Array where Element: SectionModelType, Element.Item == BaseCellModelProtocol {
   subscript(_ indexPath: IndexPath) -> BaseCellModel? {
       self[indexPath.section].items.compactMap { $0 as? BaseCellModel }[indexPath.row]
   }
}
extension Array where Element == BaseCellModel {
    func filter<T: BaseCellModel>(type of: T.Type) -> [T] { compactMap { $0 as? T } }
    
    func item(_ identifier: String) -> BaseCellModel? {
        filter { $0.identifier == identifier }.compactMap { $0 }.first
    }
    
    func item<Identifier>(_ identifier: Identifier) -> BaseCellModel?
        where Identifier: RawRepresentable, Identifier.RawValue == String {
        filter { $0.identifier == identifier.rawValue }
        .compactMap { $0 }.first
    }
}

typealias RxDataSourcesConfiguration<T: SectionModelType> =
    (TableViewSectionedDataSource<T>, UITableView, IndexPath, T.Item) -> UITableViewCell
