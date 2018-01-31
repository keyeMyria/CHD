//
//  FitnessViewController.swift
//  tabView
//
//  Created by CenSoft on 05/12/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

class FitnessViewController: UITableViewController {

    var count = 1
    var array:[PostData] = []
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

        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "LoadingCell", bundle: Bundle.main), forCellReuseIdentifier: "loading")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        APIManager.sharedInstance.getFitnessData(pageCount: count, reference: APIReference) { [weak self] (array, pageCount) in
            if let strongSelf = self {
                if (strongSelf.count) < pageCount {
                    strongSelf.shouldShowLoadingCell = true
                } else {
                    strongSelf.shouldShowLoadingCell = false
                }

                for i in 0..<array.count{
                    strongSelf.array.append(array[i])
                }
                strongSelf.count += 1
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }
}

extension FitnessViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoadingIndexPath(indexPath) {
            return 50.0
        }  else {
            if UIDevice().userInterfaceIdiom == .pad {
                return 400.0
            } else {
                return 250.0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = array.count
        return shouldShowLoadingCell ? count + 1 : count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoadingIndexPath(indexPath) {
            if count != 1 {fetchData()}
            let cell = tableView.dequeueReusableCell(withIdentifier: "loading") as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        } else {
            let post = array[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PostTableViewCell
            cell.date.text = formattedDate(post.post_date!)
            cell.authorName.text = post.post_author
            cell.authorThumbnail.sd_setImage(with: URL(string: post.post_author_image!), placeholderImage: #imageLiteral(resourceName: "userPlaceholder"))
            cell.category.text = post.category_slug
            cell.postTitle.text = post.post_title
            let desc = post.post_description
            let postDescription = desc?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            cell.shortDescription.text = postDescription
            cell.postThumbnail.sd_setImage(with: URL(string: post.post_thumbnail_url!), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = array[indexPath.row]
        
        let postURL = post.post_title_url
        let postTitle = post.post_title
        let vc = DetailsViewController()
        vc.pageTitle = postTitle!
        vc.postURL = postURL!
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FitnessViewController {
    func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else {return false}
        return indexPath.row == self.array.count
    }
}

extension FitnessViewController {
    func formattedDate(_ string: String) -> String {
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)
        dateFormatter.dateFormat = "MMM dd yyyy"
        dateFormatter.locale = tempLocale
        return dateFormatter.string(from: date!)
    }
}

