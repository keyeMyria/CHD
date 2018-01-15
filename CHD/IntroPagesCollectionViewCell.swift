//
//  IntroPagesCollectionViewCell.swift
//  CHD
//
//  Created by CenSoft on 11/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//

import UIKit

class IntroPagesCollectionViewCell: UICollectionViewCell {
    
    var page: Page? {
        didSet {
            guard let unwrappedPage = page else {
                return
            }
            introImage.image = UIImage(named: unwrappedPage.imageName)
        }
    }
    
    let introImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = UIViewContentMode.scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var str: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(introImage)
        introImage.frame = contentView.frame
        //addConstraintsToImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraintsToImage() {
        addSubview(introImage)
        introImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        introImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        introImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        introImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
