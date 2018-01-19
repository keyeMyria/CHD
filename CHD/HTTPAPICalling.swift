//
//  HTTPAPICalling.swift
//  CHD2
//
//  Created by CenturySoft on 11/28/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

struct JSONResult: Decodable {
    let reference: String?
    let errorCode: String?
    let errorMessage: String?
    let pageNo:String?
    let pageSize: String?
    let pageCount: Int?
    let data:[PostData]?
    let message: String?
    let error: Int?
}

struct PostData: Decodable {
    let post_id: Int?
    let post_url: String?
    let post_title: String?
    let post_title_url: String?
    let post_author_id: String?
    let post_author: String?
    let post_author_image: String?
    let post_thumbnail_url: String?
    //let post_small_thumbnail_url: String?
    let category_slug: String?
    let category_id: Int?
    let post_description: String?
    let post_date: String?
}

class HTTPAPICalling{

    class var sharedInstance :HTTPAPICalling {
        struct Singleton {
            static let instance = HTTPAPICalling()
        }
        
        return Singleton.instance
    }
    
    func makeRequestForAPI(requestMethod:String, requestURL:String, requestParaDic:[String: Any]?, completion: @escaping (JSONResult?) -> ()) {
        let url = URL(string: requestURL)
        var request = URLRequest(url: url!)
        request.httpMethod = requestMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let requestDict = requestParaDic {
            do{
            let jsonData = try JSONSerialization.data(withJSONObject: requestDict, options: .prettyPrinted)
                    request.httpBody = jsonData
            } catch {
                print(error)
            }
        }
        URLSession.shared.dataTask(with:request) { (data, _, error) in
            if error != nil {
                self.failuareDialog(title: "No internet connection", message: "Please check your internet connection and try again")
            } else {
                do {
                    guard let data = data else {return}
                    let parsedData = try JSONDecoder().decode(JSONResult.self, from: data)
                    
                    completion(parsedData)
                }
                catch {
                   self.failuareDialog(title: "Something went wrong", message: "It's not you, it's us. Sorry for inconvenience")
                }
            }
            
            }.resume()
    }
    
    func fetchAPIByRegularConvention(requestMethod:String, requestURL:String, requestParaDic:[String: String]?, completion: @escaping (NSDictionary?) -> ()) {
        let url = URL(string: requestURL)
        var request = URLRequest(url: url!)
        request.httpMethod = requestMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let requestDict = requestParaDic {
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: requestDict, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                print(error)
            }
        }
        URLSession.shared.dataTask(with:request) { (data, _, error) in
            if error != nil {
                self.failuareDialog(title: "No internet connection", message: "Please check your internet connection and try again")
            } else {
                do {
                    guard let data = data else {return}
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                    completion(parsedData)
                }
                catch {
                    self.failuareDialog(title: "Something went wrong", message: "It's not you, it's us. Sorry for inconvenience")
                }
            }
            
            }.resume()
    }
    
    func failuareDialog(title: String, message: String) {
        print("showing alert", message)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let window = appDelegate.window {
            alert.view.frame = CGRect(x: 20, y: window.frame.height / 2, width: window.frame.width - 40, height: 50)
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
