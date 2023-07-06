//
//  Functions.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

func run<R>(closure: () -> R) -> R {
    closure()
}

func with<T, R>(_ receiver: T, closure: (T) -> R) -> R {
    closure(receiver)
}

func unspecified<T>() -> T {
    preconditionFailure("\(T.self) is not specified")
}
