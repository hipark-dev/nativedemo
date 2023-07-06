//
//  LineCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit

class LineCell: BaseCell {
    private let lineView: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? LineCellModelProtocol else { return }
        lineView.lets {
            $0.backgroundColor = cellModel.lineColor
            $0.snp.remakeConstraints { maker in
                maker.edges.equalTo(contentView).inset(cellModel.edgeInsets)
                maker.height.equalTo(cellModel.height)
            }
        }
    }
}
