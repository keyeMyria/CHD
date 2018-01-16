//
//  FavouriteViewController.swift
//  CHD
//
//  Created by CenSoft on 16/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//

import UIKit

class FavouriteViewController: UITableViewController {

    var pageCount = 1
    var array = [[NSDictionary]]()
    var favArray = [Int]()
    var shouldShowLoadingCell = true
    var APIReference = "health_center"
    var pageTitle = "Choose a category"

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

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
            self.array.append(data["Mens_Health"] as! [NSDictionary])
            self.array.append(data["Women_Health"] as! [NSDictionary])
            self.array.append(data["General_Health"] as! [NSDictionary])

            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        let doneButton = UIBarButtonItem()
        doneButton.title = "Done"
        doneButton.target = self
        doneButton.action = #selector(doneButtonDidClicked)
        self.navigationItem.rightBarButtonItem = doneButton

        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    @objc func doneButtonDidClicked() {
        print("done")
        var userID: String = ""
        if APIManager.sharedInstance.isKeyPresentInUserDefaults(key: "userID") {
            userID = UserDefaults.standard.value(forKey: "userID") as! String
        }
        let requestParamers = ["user_id": userID,
                               "category_ids":favArray] as [String : Any]
        LoginViewController.sharedInstance.loginWebService(requestParaDict: requestParamers, requestMethod: POST, requestURL: ADD_TO_FAVOURITE_URL) { [weak self] (result) in
            if let strongSelf = self {
                print(result.errorCode ?? "default error")
                DispatchQueue.main.async {
                    strongSelf.appDelegate.setupTabBarController()
                    let vc = FirstViewController()
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                }
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
            return "Beauty & Skin Care"
        case 1:
            return "Men's Health"
        case 2:
            return "Women's Health"
        case 3:
            return "General Health"
        default:
            return "default"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let posts = array[indexPath.section][indexPath.row]
        let categoryID = posts["cat_id"]

        if categoryID is NSNull {
            print("inside")
        } else {
            let title = posts["post_title"] as! String
            cell?.textLabel?.text = title
        }

        if favArray.contains(categoryID as! Int) {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = array[indexPath.section][indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        let category = post["cat_id"] as! Int

        if cell.accessoryType == .none {
            someMethodToCall(category: category)
            print(favArray)
        } else {
            favArray = favArray.filter{$0 != category}
            print(favArray)
        }
        self.tableView.reloadData()
    }

    func accesoryType(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCellAccessoryType  {
        return cell.accessoryType
    }

    func someMethodToCall(category: Int) {
        print(category)
        favArray.append(category)
    }
}

extension FavouriteViewController {
    func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else {return false}
        return indexPath.row == self.array.count
    }
}
