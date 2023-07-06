//
//  Arguments.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//
import UIKit
import RxSwift
import RxCocoa

protocol GenericArgrumentsProtocol {}
protocol ConfigurableAsGenericArguments {
    func configure(with arg: GenericArgrumentsProtocol)
}
protocol InstantiableAsGenericArguments {
    static func instantiate(_ arg: GenericArgrumentsProtocol) -> Self
}

extension String: GenericArgrumentsProtocol {}
extension NSAttributedString: GenericArgrumentsProtocol {}
extension Int: GenericArgrumentsProtocol {}
extension Int64: GenericArgrumentsProtocol {}
extension Float: GenericArgrumentsProtocol {}
extension Double: GenericArgrumentsProtocol {}
extension CGFloat: GenericArgrumentsProtocol {}
extension Array: GenericArgrumentsProtocol {}
extension Dictionary: GenericArgrumentsProtocol {}
extension KeyValuePairs: GenericArgrumentsProtocol {}
extension BaseCellModel: GenericArgrumentsProtocol {}
