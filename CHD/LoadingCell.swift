//
//  LoadingCell.swift
//  tabView
//
//  Created by CenSoft on 04/12/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
