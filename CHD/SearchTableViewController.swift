//
//  SearchTableViewController.swift
//  tabView
//
//  Created by CenSoft on 06/12/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    lazy var noRecordView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.frame = self.view.frame
        let label = UILabel()
        label.frame = CGRect(x: (self.view.frame.width / 2) - 125, y: self.view.frame.height / 3, width: 250, height: 50)
        label.text = "No record found"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        view.addSubview(label)
        return view
    }()

    lazy var searchBar:UISearchBar = UISearchBar()
    var array = [PostData]()
    var shouldShowLoadingCell = false
    var pageCount = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Search Post Page")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        view.backgroundColor = .white
        
        tableView.rowHeight = 50
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()

        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "LoadingCell", bundle: Bundle.main), forCellReuseIdentifier: "loading")
        
        tableView.keyboardDismissMode = .onDrag
        searchBar.placeholder = "Type here"
        
        let rightBarButtonView = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = rightBarButtonView
        
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width - 100, height: 20)
        
        if #available (iOS 11.0, *){
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        array.removeAll()
        self.noRecordView.removeFromSuperview()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("start fetching data")
        shouldShowLoadingCell = true
        searchBar.resignFirstResponder()
        
        fetchAPI()
        
    }
    
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    

    // MARK: - Table view data source
    
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = array.count
        return shouldShowLoadingCell ? count + 1 : count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingIndexPath(indexPath) {
            if pageCount != 1 {fetchAPI()}
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
extension SearchTableViewController {
    func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else {return false}
        return indexPath.row == self.array.count
    }
}

extension SearchTableViewController {
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

extension SearchTableViewController {
    func fetchAPI() {
        APIManager.sharedInstance.searchingFunction(pageCount: pageCount,searchKeyword: searchBar.text!) { [weak self] (result) in
            if result?.errorCode == "1"{
                print("No records found")
                DispatchQueue.main.async {
                    self?.tableView.addSubview((self?.noRecordView)!)
                }
                return
            }
            guard let array = result?.data else {return}
            for i in 0..<array.count {
                self?.array.append(array[i])
            }
            self?.pageCount += 1
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}
