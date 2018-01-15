//
//  ReviewTableViewController.swift
//  tabView
//
//  Created by CenSoft on 06/12/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

class ReviewTableViewController: UITableViewController {

    var pageCount = 1
    var array = [[NSDictionary]]()
    var shouldShowLoadingCell = true
    var APIReference = String()
    var pageTitle = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = pageTitle
        
        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: pageTitle)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])

        tableView.rowHeight = 50
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        tableView.tableFooterView = UIView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "LoadingCell", bundle: Bundle.main), forCellReuseIdentifier: "loading")
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        APIManager.sharedInstance.getReviewData(pageCount: pageCount, reference: APIReference) { (dict) in
            guard let dictionary = dict else {return}
            let data = dictionary["data"] as! NSDictionary
            
            self.array.append(data["Beauty_Skin_Care"] as! [NSDictionary])
            self.array.append(data["Mens_Womens_Health"] as! [NSDictionary])
            self.array.append(data["General_Health"] as! [NSDictionary])
            self.array.append(data["CBD_Hemp_Oil_Review"] as! [NSDictionary])
            
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
        
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
            return "BEAUTY & SKIN CARE"
        case 1:
            return "MEN'S & WOMEN'S HEALTH"
        case 2:
            return "GENERAL HEALTH"
        case 3:
            return "CBD & HEMP OIL REVIEW"
        default:
            return "default"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            let posts = array[indexPath.section][indexPath.row]
            let title = posts["post_title"] as! String
            cell.textLabel?.text = title
            return cell
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

extension ReviewTableViewController {
    func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else {return false}
        return indexPath.row == self.array.count
    }
}
