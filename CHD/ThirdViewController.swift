//
//  ThirdViewController.swift
//  tabView
//
//  Created by CenSoft on 27/11/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    
    
    var arrayOfNotication : Array<NotificationItem> = [];
    private var myTableView: UITableView!
    
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
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: "title") != nil) {
            
            let notification = NotificationItem.init(titleString: userDefaults.object(forKey: "title") as! String, url_Link: userDefaults.object(forKey: "url") as! String)
            arrayOfNotication.append(notification)
            
            let newVC = DetailsViewController()
            newVC.postURL = notification.url_Link
            newVC.pageTitle = notification.titleString
            newVC.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(newVC, animated: true)
        }
       
        if arrayOfNotication.count == 0
        {
            let label = UILabel()
            label.text = "No notifications"
            label.textColor = .lightGray
            label.textAlignment = .center
            label.font = UIFont.monospacedDigitSystemFont(ofSize: 17.0, weight: .semibold)
            label.frame = CGRect(x: (view.frame.width / 2) - 100, y: view.frame.height / 2, width: 200, height: 30)
            view.addSubview(label)
        }else
        {
            myTableView = UITableView(frame: CGRect(x: 0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
            myTableView.dataSource = self
            myTableView.delegate = self
            myTableView.tableFooterView=nil
            self.view.addSubview(myTableView)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfNotication.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        let notification = arrayOfNotication[indexPath.row]
        cell.textLabel!.text = notification.titleString;
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        let notification = arrayOfNotication[indexPath.row]
        //        let urlString = notification.url_Link;
        
        let newVC = DetailsViewController()
        newVC.postURL = notification.url_Link
        newVC.pageTitle = notification.titleString
          newVC.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
}

