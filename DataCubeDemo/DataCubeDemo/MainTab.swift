//
//  MainTab.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/15.
//

import Foundation
import UIKit

enum MainTab: EnumCollection {
    case top
    case trade
    case explorer
    case more
    
    var viewController: UIViewController.Type {
        properties.viewController
    }
    
    var title: String {
        properties.title
    }
    
    var imageName: String {
        properties.imageName
    }
    
    var selectedImageName: String {
        properties.selectedImageName
    }
}

extension MainTab {
    typealias Properties = (
        viewController: UIViewController.Type,
        title: String,
        imageName: String,
        selectedImageName: String
    )
    
    var properties: Properties {
        switch self {
        case .top:
            return (TopViewController.self, "top", "home", "home")
        case .trade:
            return (TradeViewController.self, "trade", "card", "card")
        case .explorer:
            return (ExplorerViewController.self, "explorer", "chart", "chart")
        case .more:
            return (MoreViewController.self, "more", "setting", "setting")
        }
    }
}

extension MainTab {
    static var allTabs: [MainTab] {
        [top, trade, explorer, more]
    }
    
    static func tab(from viewController: UIViewController) -> MainTab {
        MainTab.allTabs.filter {
            viewController.isKind(of: $0.properties.viewController)
        }.first ?? .top
    }
}
