//
//  AboutUsViewController.swift
//  tabView
//
//  Created by CenSoft on 29/11/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {

    let webView = UIWebView()
    var pageTitle = String()
    var pageURL = String()
    var isStaticPage = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = pageTitle
        
        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: pageTitle)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
      
        view.backgroundColor = .white
        
        let yPosition = 60;
        
        let topView = UIView.init(frame: CGRect.init(x: 0, y: yPosition, width: Int(view.frame.size.width), height: 60))
        view.addSubview(topView)
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 10, y: 5, width: 55, height: 55))
        imageView.image = #imageLiteral(resourceName: "logo")//UIImage.init(named: "logo.png")
        imageView.layer.cornerRadius = 27.5
        topView.addSubview(imageView)
        
        let webLabel = UILabel.init(frame: CGRect.init(x: 70, y: 5, width: Int(view.frame.size.width-80), height: 35))
        webLabel.text = "Consumer Health Digest"
        webLabel.textColor = UIColor.black
        webLabel.font = UIFont.systemFont(ofSize: 20)
        topView.addSubview(webLabel)
        
        let versionLabel = UILabel.init(frame: CGRect.init(x: 70, y: 35 , width: Int(view.frame.size.width-80), height: 20))
        versionLabel.text = "Version : 1.0.0.0"
        versionLabel.textColor = UIColor.gray
        versionLabel.font = UIFont.systemFont(ofSize: 15)
        topView.addSubview(versionLabel)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapGhestureRecognizer))
        topView.addGestureRecognizer(tapGesture)
        
        webView.frame = CGRect(x: 0, y: topView.frame.size.height + topView.frame.origin.y, width: view.frame.width, height: view.frame.height - (topView.frame.size.height + topView.frame.origin.y))
        webView.delegate = self
        webView.scrollView.delegate = self
        webView.backgroundColor = UIColor.white
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        activityIndicator.center = webView.center
        activityIndicator.startAnimating()
    }
    
    @objc func tapGhestureRecognizer()
    {
       UIApplication.shared.openURL(URL(string: "https://www.consumerhealthdigest.com")!)
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchAPI()
    }
    
    func fetchAPI() {
        APIManager.sharedInstance.getAboutUSData(requestURL: pageURL) { [weak self] (dict) in
            if let strongSelf = self {
                if let post = dict?.data{
                    let titlee = post[0].post_title
                    let descriptionn = post[0].post_description
                    let desc = descriptionn?.replacingOccurrences(of: "\n<div class='adress'><img src='http://uat.mobodesk.com/chd-api/wp-content/uploads/2011/05/address.png' alt='address'  class='alignnone' /></div>\n<div class='adress1024'><img src='http://uat.mobodesk.com/chd-api/wp-content/uploads/2017/03/address-1024.png' alt='address'  class='alignnone' /></div>\n<div class='adress600'><img src='http://uat.mobodesk.com/chd-api/wp-content/uploads/2017/03/address-600.png' alt='address'  class='alignnone' /></div>", with: " ", options: String.CompareOptions.caseInsensitive, range: nil)
                    let descWithoutAnchor = desc?.replacingOccurrences(of: "<a href='http://uat.mobodesk.com/chd-api/'>ConsumerHealthDigest.com</a>", with: "ConsumerHealthDigest.com", options: String.CompareOptions.caseInsensitive, range: nil)
                    let descToLoad = descWithoutAnchor?.replacingOccurrences(of: "<a href='/general/contact-us.html'>Contact Us</a>", with: "Contact Us", options: String.CompareOptions.caseInsensitive, range: nil)
                    DispatchQueue.main.async {
                        strongSelf.loadWebView(title: titlee!, desc: descToLoad!)
                    }
                }
            }
        }
    }
    
    func loadWebView(title: String, desc: String){
        self.webView.loadHTMLString(desc, baseURL: nil)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
