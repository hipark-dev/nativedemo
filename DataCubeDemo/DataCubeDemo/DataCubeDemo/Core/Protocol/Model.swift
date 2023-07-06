//
//  Model.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import RxSwift

protocol TransactionModel: GenericArgrumentsProtocol {}
protocol ResponseModel: TransactionModel {}
protocol RequestModel: TransactionModel {}
protocol RequestJwsModel: TransactionModel {}
protocol EmptyResponseProtocol: TransactionModel {}

protocol ViewModelStream {
    associatedtype Input
    associatedtype Output
    
    var inputs: Input { get }
    var outputs: Output { get }
}

extension ViewModelStream {
    @discardableResult
    func transform(inputs closure: ((Input) -> Void)?) -> Output {
        closure?(inputs)
        return outputs
    }
}

protocol ViewModelStreamInternals {
    associatedtype Base
    init(base: Base)
}
