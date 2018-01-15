//
//  ThirdViewController.swift
//  tabView
//
//  Created by CenSoft on 27/11/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notifications"
        
        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Notification")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        if #available (iOS 11.0, *){
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "No notifications"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 17.0, weight: .semibold)
        label.frame = CGRect(x: (view.frame.width / 2) - 100, y: view.frame.height / 2, width: 200, height: 30)
        view.addSubview(label)
        // Do any additional setup after loading the view.
    }
    
}
