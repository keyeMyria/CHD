//
//  ImageCell.swift
//  PetMessageApp
//
//  Created by James Rochabrun on 12/12/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var label: UILabel!
    var blurView: UIView!
    var checkView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        contentView.addSubview(imageView)

        blurView = UIView()
        blurView.backgroundColor = .black
        blurView.alpha = 0.5
        imageView.addSubview(blurView)

        checkView = UIImageView()
        checkView.image = #imageLiteral(resourceName: "icons8-ok_filled")
        checkView.alpha = 0
        contentView.addSubview(checkView)

        label = UILabel()
        label.text = "Anti Aging lorem ipsum"
        label.textColor = .white
        label.alpha = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        contentView.addSubview(label)

        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

        var frame = imageView.frame
        frame.size.height = self.frame.size.height
        frame.size.width = self.frame.size.width
        frame.origin.x = 0
        frame.origin.y = 0
        imageView.frame = frame

        blurView.frame = imageView.frame

        checkView.frame = CGRect(x: self.frame.width - 30, y: 10, width: 20, height: 20)

        label.frame = CGRect(x: 0, y: self.frame.height - 50, width: self.frame.size.width, height: 50)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
