//
//  Optional+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

extension Optional where Wrapped == String {
    func unwrap(_ placeHolder: String = UIConstant.empty) -> Wrapped {
        guard let self = self else { return placeHolder }
        return self
    }
}
