//
//  LineCellModel.swift
//  TWBank
//
//  Created by KyuHo.Son on 17/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

protocol LineCellModelProtocol {
    var edgeInsets: UIEdgeInsets { get set }
    var height: CGFloat { get set }
    var lineColor: UIColor { get set }
}

class LineCellModel: BaseCellModel, LineCellModelProtocol {
    override var cellIdentifier: UITableViewCell.Type {
        LineCell.self
    }
    
    var edgeInsets: UIEdgeInsets
    var height: CGFloat
    var lineColor: UIColor

    init(height: CGFloat, lineColor: UIColor, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        
        self.edgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        self.height = height
        self.lineColor = lineColor
        if height + edgeInsets.bottom + edgeInsets.top < 1 {
            edgeInsets.bottom = 1 - height - edgeInsets.top
        }
        
    }
}

class AnimatableLineCellModel: AnimatableBaseCellModel, LineCellModelProtocol {
    override var cellIdentifier: UITableViewCell.Type {
        LineCell.self
    }
    
    var edgeInsets: UIEdgeInsets
    var height: CGFloat
    var lineColor: UIColor
    
    init(height: CGFloat, lineColor: UIColor, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        
        self.edgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        self.height = height
        self.lineColor = lineColor
        if height + edgeInsets.bottom + edgeInsets.top < 1 {
            edgeInsets.bottom = 1 - height - edgeInsets.top
        }
        
        let identity = "height:\(height),lineColor:\(lineColor),edgeInsets:\(edgeInsets)"
        super.init(identity: identity)
    }
    
    static func == (lhs: AnimatableLineCellModel, rhs: AnimatableLineCellModel) -> Bool {
        lhs.edgeInsets == rhs.edgeInsets && lhs.height == rhs.height && lhs.lineColor == rhs.lineColor
        
    }
}
