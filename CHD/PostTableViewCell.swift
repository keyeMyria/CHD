//
//  PostTableViewCell.swift
//  tabView
//
//  Created by CenSoft on 30/11/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var authorThumbnail: UIImageView!
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var postThumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        authorThumbnail.layer.cornerRadius = 18
        authorThumbnail.clipsToBounds = true
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
