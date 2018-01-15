//
//  HealthConditionViewController.swift
//  tabView
//
//  Created by CenSoft on 05/12/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

class HealthConditionViewController: UITableViewController {

    var count = 1
    var array = [PostData]()
    var shouldShowLoadingCell = true
    let APIReference = "health_condition"
    var sections : [(index: Int, length :Int, title: String)] = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Health Conditions"
        
        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Health Condition")
        
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
        
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    func fetchData() {
        APIManager.sharedInstance.getHealthConditionData(pageCount: count, reference: APIReference) { [weak self] (array) in
            if let strongSelf = self {
                for i in 0..<array.count{
                    strongSelf.array.append(array[i])
                }
                if array.count > 0 {
                    strongSelf.shouldShowLoadingCell = false
                }
                strongSelf.count += 1
                strongSelf.sortData()
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }
    
    func sortData() {
        var index = 0
        for i in 0..<array.count  {
            let commonPrefix = array[i].post_title?.commonPrefix(with: array[index].post_title!, options: .caseInsensitive)
            
            if (commonPrefix?.isEmpty)! {
                
                let string = array[index].post_title?.uppercased();
                
                let firstCharacter = string![(string?.startIndex)!]
                
                let title = "\(firstCharacter)"
                
                let newSection = (index: index, length: i - index, title: title)
                print(newSection.title)
                sections.append(newSection)
                index = i;
            }
        }
    }
}

extension HealthConditionViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return sections[section].title
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map { $0.title }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].length
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = array[sections[indexPath.section].index + indexPath.row].post_title
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = array[sections[indexPath.section].index + indexPath.row]
        
        let postURL = post.post_url
        let postTitle = post.post_title
        let vc = DetailsViewController()
        vc.pageTitle = postTitle!
        vc.postURL = postURL!
        vc.hidesBottomBarWhenPushed = true
        
        
        if postURL != nil {
            
            let lastChar = postURL?.last;
            
            if lastChar != "#"
            {
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let alertView = UIAlertController.init(title: "Alert", message: "No contents", preferredStyle: UIAlertControllerStyle.alert)
                alertView.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                self.navigationController?.present(alertView, animated: true, completion: nil)
            }
        }else
        {
            let alertView = UIAlertController.init(title: "Alert", message: "No contents", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            self.navigationController?.present(alertView, animated: true, completion: nil)
        }
       
    }
    
    
}

extension HealthConditionViewController {
    func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else {return false}
        return indexPath.row == self.array.count
    }
}
