//
//  CategoryTableViewCell.swift
//  CHD
//
//  Created by CenSoft on 16/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    var link: FavouriteViewController?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

//        let checkButton = UIButton(type: .system)
//        checkButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
//        checkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        accessoryView = checkButton
//
//        checkButton.addTarget(self, action: #selector(addItemToFavourities), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
