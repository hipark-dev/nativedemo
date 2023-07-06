//
//  MessageCardCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MessageCardCell: BaseCell {
    
    enum Constants {
        static let colorPoint: Int = 11
        static let itemScrollWidth: Int = 165
        static let selectedCardDetectOffset: CGFloat = 100
    }
    
    @IBOutlet private weak var underLineView: UIView!
    
    @IBOutlet private weak var messageTextField: UITextField!
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(MessageCardCollectionCell.self)
            collectionView.register(MessageCardEmptyCollectionViewCell.self)
        }
    }
    
    var messageTextFieldDriver: Driver<String?> {
        messageTextField.rx.text.changed.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: nil)
    }
    
    var checkedCard = MessageCardCollectionCellModel(SupportAPIModel.MessageCardInfo())
    var viewModel: JointMoneyRequestViewModelType = JointMoneyRequestViewModel()
    var splitBillViewModel: SplitBillAmountViewModelType = SplitBillAmountViewModel()
    var requestConfirmViewModel: RequestConfirmViewModelType = RequestConfirmViewModel()
    
    var isLoaded: Bool = false
    var viewTypeClass: MessageCardCellModel.EnterClassType = .jointMoneyRequest
    
    override func bindStyles() {
        self.lets {
            $0.selectionStyle = .none
        }
        
        collectionView.lets {
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.decelerationRate = UIScrollView.DecelerationRate.fast
        }
        
        underLineView.lets {
            $0.backgroundColor = StyleColor.gray_E9E9E9.apply
        }
    }
    
    override func bindViewModel() {
        
        collectionView.rx.didEndDragging.asDriver()
            .drive(onNext: { [weak self] _ in

                self?.setSelectedCardOffset()
                
            }).disposed(by: disposeBag)
        
        collectionView.rx.didEndDecelerating.asDriver()
            .drive(onNext: { [weak self] _ in

                self?.setSelectedCardOffset()

            }).disposed(by: disposeBag)
  
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        
        guard let cellModel = value as? MessageCardCellModel else { return }
        
        isLoaded = false
        viewTypeClass = cellModel.viewTypeClass
        
        switch cellModel.viewTypeClass {
        case .jointMoneyRequest:
             viewModel = cellModel.viewModel
        case .splitBillAmount:
            splitBillViewModel = cellModel.splitBillViewModel
        case .requestConfirm:
            requestConfirmViewModel = cellModel.requestConfirmViewModel
            underLineView.isHidden = true
        }
        
        let sections: [MessageCardCollectionSectionModel] = [.cardSection(cellModel.cardList)]
        
        Observable.just(sections)
            .bind(to: collectionView.rx.items(dataSource: makeDataSource()))
            .disposed(by: disposeBag)
    }
    
    private func setSelectedCardOffset() {
        
        let center = collectionView.center
        let position = convert(CGPoint(x: center.x - Constants.selectedCardDetectOffset, y: center.y), to: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: position) else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let cardCell = cell as? MessageCardCollectionCell else { return }

        cardCell.sendTapAction()
        
    }
}

extension MessageCardCell {
    private func makeDataSource() ->
        RxCollectionViewSectionedReloadDataSource<MessageCardCollectionSectionModel> {
            RxCollectionViewSectionedReloadDataSource<MessageCardCollectionSectionModel>(
                configureCell: { _, collectionView, indexPath, element -> UICollectionViewCell in
                    let cell = collectionView.dequeueBaseCell(class: element.cellIdentifier, for: indexPath, configure: element)
                    
                    if let cardCollection = cell as? MessageCardCollectionCell {
                        
                        guard let cellModel = element as? MessageCardCollectionCellModel else {
                            return cell
                        }
                        
                        if !self.isLoaded && (indexPath.row == 0) {
                            self.checkedCard = cellModel
                            self.messageTextField.text = cellModel.message
                            
                            switch self.viewTypeClass {
                            case .jointMoneyRequest:
                                self.viewModel.inputs.setCheckCard(cellModel)
                            case .splitBillAmount:
                                self.splitBillViewModel.inputs.setCheckCard(cellModel)
                            case .requestConfirm:
                                self.requestConfirmViewModel.inputs.setCheckCard(cellModel)
                            }
                            
                            self.messageTextField.textColor = cellModel.messageColor.uiColor
                        }
                        
                        if self.checkedCard.cardID == cellModel.cardID {
                            cellModel.isChecked = true
                        } else {
                            cellModel.isChecked = false
                        }
                        cardCollection.setCheckbox(cellModel)
                        
                        self.isLoaded = true
                       
                        cardCollection.coverButtonDriver.drive(
                            onNext: { [weak self] _ in
                                
                                self?.checkedCard = cellModel
                                switch self?.viewTypeClass {
                                case .jointMoneyRequest?:
                                    self?.viewModel.inputs.setCheckCard(cellModel)
                                case .splitBillAmount?:
                                    self?.splitBillViewModel.inputs.setCheckCard(cellModel)
                                case .requestConfirm?:
                                    self?.requestConfirmViewModel.inputs.setCheckCard(cellModel)
                                case .none:
                                    break
                                }
                                
                                self?.messageTextField.text = cellModel.message
                
                                self?.messageTextField.textColor = cellModel.messageColor.uiColor
                
                                collectionView.reloadData()
                                
                                if indexPath.row >= Int.zero {
                                    let offsetX = CGFloat(Constants.itemScrollWidth * indexPath.row)
                                    collectionView.setContentOffset(CGPoint(x: offsetX, y: collectionView.contentOffset.y), animated: false)
                                }
                                
                            }).disposed(by: self.disposeBag)
                         
                    }
                    
                    return cell
                }
            )
    }
}
