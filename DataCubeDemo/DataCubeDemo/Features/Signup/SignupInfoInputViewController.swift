//
//  SignupInfoInputViewController.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/07/01.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import Reusable
import SnapKit

class SignupInfoInputViewController: BaseViewController, StoryboardView {
    
    typealias Reactor = SignupInfoInputViewReactor
    
    var fullButton: FullButton?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(MarginCell.self)
            tableView.register(TitleCell.self)
            tableView.lets {
                $0.rowHeight = UITableView.automaticDimension
                $0.separatorInset = .zero
                $0.allowsSelection = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = Reactor()
    }
    
    override func bindStyles() {
        setBackButton()
    }
    
    override func bindFullButtonIfNeeded() {
        guard let fullButton = fullButton else { return }
            
        fullButton.lets {
            $0.bindStyles()
            $0.configureButton(.enable, title: "가입하기")
        }

    }
    
    func bind(reactor: SignupInfoInputViewReactor) {
        
        fullButton?.tapEvent().map{ Reactor.Action.fullButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .observe(on: MainScheduler.instance)
            .map{ $0.sections }
            .bind(to: tableView.rx.items(dataSource: self.makeDataSource()))
            .disposed(by: disposeBag)
    }
}

extension SignupInfoInputViewController {
    func makeDataSource() -> RxTableViewSectionedReloadDataSource<SignupInfoInputViewSection> {
        RxTableViewSectionedReloadDataSource<SignupInfoInputViewSection>(
            configureCell: { _, tableView, indexPath, sectionItem -> UITableViewCell in
                switch sectionItem {
                case .titleCell(let reactor):
                    let cell = tableView.dequeueReusableCell(for: indexPath) as TitleCell
                    cell.reactor = reactor
                    return cell
                case .marginCell(let reactor):
                    let cell = tableView.dequeueReusableCell(for: indexPath) as MarginCell
                    cell.reactor = reactor
                    return cell
                default: return UITableViewCell()
                }
                
            }
        )
    }
}


extension SignupInfoInputViewController {
    private func next(_ args: Void? = nil) {
        
    }
}

extension SignupInfoInputViewController: NeedFullButtonProtocol { }
