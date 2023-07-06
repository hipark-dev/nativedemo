//
//  PhotoListCell.swift
//  TWBank
//
//  Created by Sunwoo.Kim on 27/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PhotoListCell: BaseCell {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(PhotoCollectionCell.self)
        }
    }
    
    var itemSelectDriver: Driver<IndexPath> {
        collectionView.rx.itemSelected.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: IndexPath(item: 0, section: 0))
    }
     
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
}

extension PhotoListCell {
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
}
