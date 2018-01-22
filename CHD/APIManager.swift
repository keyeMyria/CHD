//
//  APIManager.swift
//  CHD2
//
//  Created by CenturySoft on 11/28/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

class APIManager {
    
    var array:[PostData] = []
    var mutablePageCount = 1
    var delegate: (() -> ())?
    var shouldShowLoadingCell = true
    var reloadTableView = true
    
    class var sharedInstance :APIManager {
        struct Singleton {
            static let instance = APIManager()
        }
        
        return Singleton.instance
    }
    
    init() {
//        getResentPostsData(pageCount: mutablePageCount) {
//            self.mutablePageCount += 1
//        }
    }
    
    func getResentPostsData(pageCount: Int, completion: @escaping () -> ()) {
        var categoryArray = [Int]()
        let userID = UserDefaults.standard.value(forKey: "userID") as! String
        let isCategoryAvailable = APIManager.sharedInstance.isKeyPresentInUserDefaults(key: "category")
        if isCategoryAvailable{
            categoryArray = UserDefaults.standard.value(forKey: "category") as! [Int]
        }

        var requestDict:[String: Any]
        if userID.isEmpty && !isCategoryAvailable {
            requestDict = ["pageNo":"\(pageCount)",
                "pageSize":"10",
                "reference":"homepage"]
        } else if userID.isEmpty && isCategoryAvailable {
            if categoryArray.count == 0 {
                requestDict = ["pageNo":"\(pageCount)",
                    "pageSize":"10",
                    "reference":"homepage"]
            } else {
                requestDict = ["pageNo":"\(pageCount)",
                    "pageSize":"10",
                    "reference":"homepage",
                    "categories" : categoryArray]
            }
        } else {
            requestDict = ["pageNo":"\(pageCount)",
                "pageSize":"10",
                "reference":"homepage",
                "user_id" : userID ]
        }
        HTTPAPICalling.sharedInstance.makeRequestForAPI(requestMethod: POST, requestURL: BASE_URL, requestParaDic: requestDict){(dict) in
            guard let data = dict?.data else {return}
            for i in 0..<data.count {
                self.array.append(data[i])
            }
            self.mutablePageCount += 1
            self.delegate!()
            completion()
        }
    }
    
    func getReviewData(pageCount: Int, reference: String, completion: @escaping (NSDictionary?) -> ()) {
        let requestDict:[String: String] = ["pageNo":"\(pageCount)",
            "pageSize":"10",
            "reference":reference]
        HTTPAPICalling.sharedInstance.fetchAPIByRegularConvention(requestMethod: POST, requestURL: BASE_URL, requestParaDic: requestDict) { (dict) in
            completion(dict)
        }
    }
    
    func getHealthConditionData(pageCount: Int, reference: String, completion: @escaping ([PostData]) -> ()) {
        let requestDict:[String: String] = ["pageNo":"\(pageCount)",
            "pageSize":"10",
            "reference":reference]
        HTTPAPICalling.sharedInstance.makeRequestForAPI(requestMethod: POST, requestURL: BASE_URL, requestParaDic: requestDict){(dict) in
            completion((dict?.data)!)
        }
    }

    
    func getFitnessData(pageCount: Int, reference: String, completion: @escaping ([PostData], Int) -> ()) {
        let requestDict:[String: String] = ["pageNo":"\(pageCount)",
            "pageSize":"10",
            "reference":reference]
        HTTPAPICalling.sharedInstance.makeRequestForAPI(requestMethod: POST, requestURL: BASE_URL, requestParaDic: requestDict){(dict) in
            completion((dict?.data)!, (dict?.pageCount!)!)
        }
    }
    
    func searchingFunction(pageCount: Int, searchKeyword: String, completion: @escaping (JSONResult?) -> ()) {
        let requestDict:[String: String] = ["pageNo":"\(pageCount)",
                                            "pageSize" : "10",
                                            "reference":"search_keyword",
                                            "searchkeyword":searchKeyword]
        HTTPAPICalling.sharedInstance.makeRequestForAPI(requestMethod: POST, requestURL: BASE_URL, requestParaDic: requestDict) { (result) in
            guard let data = result else {return}
            completion(data)
        }
    }
    
    func sendMessageToAdmin(requestDict: [String: String], requestURL: String, completion: @escaping (JSONResult?) -> ()) {
        HTTPAPICalling.sharedInstance.makeRequestForAPI(requestMethod: POST, requestURL: requestURL, requestParaDic: requestDict) { (result) in
            
            guard let jsonResult = result else {return}
            completion(jsonResult)
        }
    }
    
    func getAboutUSData(requestURL: String, _ complition : @escaping (JSONResult?) -> ())  {
        
        HTTPAPICalling.sharedInstance.makeRequestForAPI(requestMethod: GET, requestURL: requestURL, requestParaDic: nil){(dict) in

            complition(dict)
        }
    }

    func registerDevice(requestURL: String, completion: @escaping(NSDictionary) -> ()) {
        var userID: String = ""
        if isKeyPresentInUserDefaults(key: "userID") {
            userID = UserDefaults.standard.value(forKey: "userID") as! String
        }

        if let deviceToken = UserDefaults.standard.value(forKey: "deviceToken"){
            let requestDict = ["device_token":deviceToken,
                               "platform":"0",
                               "user_id":userID,
                               "reference":"pushnotification"]

            HTTPAPICalling.sharedInstance.fetchAPIByRegularConvention(requestMethod: POST, requestURL: requestURL, requestParaDic: requestDict as? [String : String], completion: { (dict) in
                completion(dict!)
            })
        }
    }

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func numberOfRowsInSection() -> Int{
        //return array.count
        let count = array.count
        return shouldShowLoadingCell ? count + 1 : count
    }
    
    func cellForRow(at indexPath: IndexPath, tableView: UITableView) -> PostData? {
//        if mutablePageCount == 1 && reloadTableView {
//            getResentPostsData(pageCount: mutablePageCount, completion: {
//                DispatchQueue.main.async {
//                    tableView.reloadData()
//                    self.reloadTableView = false
//                }
//            })
//        } else {
            if indexPath.row == array.count - 2 {
                getResentPostsData(pageCount: mutablePageCount) {
                }
            }
//        }
        return array[indexPath.row] as PostData
    }
    
    func didSelectRow(at indexPath: IndexPath) -> PostData? {
        return array[indexPath.row] as PostData
    }
    
    func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else {return false}
        return indexPath.row == self.array.count
    }
}
