//
//  LabelCell.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/30.
//

import UIKit
import ReactorKit

class LabelCell: BaseCell, View {
   
    let label: UILabel = UILabel()
    
    typealias Reactor = LabelCellReactor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: LabelCellReactor) {
        self.lets {
            $0.selectionStyle = .none
        }
        
        label.lets {
            $0.text = reactor.currentState.title
            $0.textColor = reactor.currentState.textColor.apply
            $0.font = reactor.currentState.numberFont?.applyDigit ?? reactor.currentState.font.apply
            $0.numberOfLines = reactor.currentState.numberOfLines
            $0.textAlignment = reactor.currentState.textAlignment
        }
        
        label.snp.remakeConstraints {
            $0.edges.equalTo(contentView).inset(reactor.currentState.edgeInsets).priority(750)
            if let height = reactor.currentState.height {
                $0.height.equalTo(height).priority(750)
            }
        }
        
        detailTextLabel?.lets {
            $0.text = reactor.currentState.detail
            $0.font = reactor.currentState.detailFont?.apply
            $0.textColor = StyleColor.dodgerBlue_4488F1.apply
            $0.numberOfLines = .zero
        }
        
        detailTextLabelConfigureIfNeeded(reactor)
        applyUnderlinedTitleIfNeeded(reactor)
        
        layoutIfNeeded()
        updateConstraintsIfNeeded()
    }
    
    func detailTextLabelConfigureIfNeeded(_ reactor: LabelCellReactor) {
        guard detailTextLabel?.superview != nil else { return }
        let detailLabelRightInsets = reactor.currentState.edgeInsets.right == 0 ? -28 : reactor.currentState.edgeInsets.right
        detailTextLabel?.snp.remakeConstraints { [unowned self] in
            $0.right.equalToSuperview().offset(detailLabelRightInsets)
            $0.lastBaseline.equalTo(self.label.snp.lastBaseline).priority(750)
        }
    }
    
    func applyUnderlinedTitleIfNeeded(_ reactor: LabelCellReactor) {
        guard reactor.currentState.isUnderlinedTitle else { return }
        label.attributedText = reactor.currentState.title.applyUnderline(label.font, color: label.textColor)
    }
}
