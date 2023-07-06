//
//  PhotoCollectionCell.swift
//  TWBank
//
//  Created by Sunwoo.Kim on 27/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class PhotoCollectionCell: BaseCollectionCell {

    @IBOutlet private weak var imageView: UIImageView!

    override func configureWith(value: BaseCollectionCellModelProtocol) {
        guard let cellModel = value as? PhotoCollectionCellModel else { return }
        imageView.ext.roundCorners(corners: .allCorners, radius: 5)
        
        switch cellModel.imageType {
        case .camera:
            imageView.backgroundColor = StyleColor.gray_F2F3F7.apply
            imageView.contentMode = .center
            imageView.image = UIImage(named: "loanCamera")
            setNeedsDisplay()
        case .image(let image):
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
        }
    }

}

extension PhotoCollectionCell {
    enum ImageType {
        case camera
        case image(UIImage)
    }
}
