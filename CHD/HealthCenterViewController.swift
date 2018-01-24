//
//  ReviewTableViewController.swift
//  tabView
//
//  Created by CenSoft on 06/12/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

class HealthCenterViewController: UITableViewController {
    
    var pageCount = 1
    var array = [[NSDictionary]]()
    var shouldShowLoadingCell = true
    var APIReference = "health_center"
    var pageTitle = "Health Center"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = pageTitle
        
        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: pageTitle)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
   
        view.addSubview(activityIndicator)
        activityIndicator.color = .black
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        tableView.rowHeight = 50
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "LoadingCell", bundle: Bundle.main), forCellReuseIdentifier: "loading")
        
        APIManager.sharedInstance.getReviewData(pageCount: pageCount, reference: APIReference) { (dict) in
            guard let dictionary = dict else {return}
            let data = dictionary["data"] as! NSDictionary
            
            self.array.append(data["Beauty_Skin_Care"] as! [NSDictionary])
            self.array.append(data["Beauty_Skin_Care_FAQs"] as! [NSDictionary])
            self.array.append(data["Mens_Health"] as! [NSDictionary])
            self.array.append(data["Mens_Health_FAQs"] as! [NSDictionary])
            self.array.append(data["Women_Health"] as! [NSDictionary])
            self.array.append(data["Women_Health_FAQs"] as! [NSDictionary])
            self.array.append(data["General_Health"] as! [NSDictionary])
            self.array.append(data["General_Halth_FAQs"] as! [NSDictionary])
            
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = array[section].count
        return count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Beauty & Skin Care"
        case 1:
            return "Beauty & Skin Care FAQ's"
        case 2:
            return "Men's Health"
        case 3:
            return "Men's Health FAQ's"
        case 4:
            return "Women's Health"
        case 5:
            return "Women's Health FAQ's"
        case 6:
            return "General Health"
        case 7:
            return "General Health FAQ's"
        default:
            return "default"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let posts = array[indexPath.section][indexPath.row]
        let title = posts["post_title"] as! String
        cell?.textLabel?.text = title
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = array[indexPath.section][indexPath.row]
        
        let postURL = post["post_url"] as! String
        let postTitle = post["post_title"] as! String
        let vc = DetailsViewController()
        vc.pageTitle = postTitle
        vc.postURL = postURL
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HealthCenterViewController {
    func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else {return false}
        return indexPath.row == self.array.count
    }
}

