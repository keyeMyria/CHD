//
//  GridLayout.swift
//  PetMessageApp
//
//  Created by James Rochabrun on 12/12/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    let innerSpace: CGFloat = 3.0
    let numberOfCellsOnRow: CGFloat = 3

    
    override init() {
        super.init()
        self.minimumLineSpacing = innerSpace
        self.minimumInteritemSpacing = innerSpace
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.size.width/self.numberOfCellsOnRow)-self.innerSpace - 5
        
    }

    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width:itemWidth(), height:itemWidth())
        }
        get {
            return CGSize(width:itemWidth(),height:itemWidth())
        }
    }
    
 
}
