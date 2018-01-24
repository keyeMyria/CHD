//
//  DetailsViewController.swift
//  tabView
//
//  Created by CenSoft on 01/12/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit

var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView()
    indicator.activityIndicatorViewStyle = .whiteLarge
    //indicator.color = .black
    indicator.hidesWhenStopped = true
    return indicator
}()

class DetailsViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate  {

    lazy var webView = UIWebView()
    var pageTitle = String()
    var postURL: String?
    
    var forceStop: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Detailed Screen - Article Page")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 28)
            case 1334:
                print("iPhone 6/6S/7/8")
                backButton.frame = CGRect(x: 0, y: 0, width: 65, height: 28)
            case 2208:
                print("iPhone 6+/6S+/7+/8+")
                backButton.frame = CGRect(x: 0, y: 0, width: 65, height: 28)
            case 2436:
                print("iPhone X")
                backButton.frame = CGRect(x: 0, y: 0, width: 65, height: 28)
            default:
                print("unknown")
                backButton.frame = CGRect(x: 0, y: 0, width: 65, height: 28)
            }
        }
        
        backButton.addTarget(self, action: #selector(backButtonDidClicked), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.title = pageTitle
       
        webView.frame = CGRect(x: 0, y: -66, width: view.frame.width, height: view.frame.height + 66)
        webView.delegate = self
        webView.scrollView.delegate = self
        webView.scrollView.bounces = false
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        activityIndicator.center = (webView.center)
        activityIndicator.startAnimating()
        if (postURL?.isEmpty)! {return}
        var urlRequest = URLRequest(url: URL(string: postURL!)!)
        urlRequest.timeoutInterval = 60.0
        self.webView.loadRequest(urlRequest)
        
        let shareButton = UIBarButtonItem(image:#imageLiteral(resourceName: "icons8-share"), style: .plain, target: self, action: #selector(shareButtonDidClicked(_:)))
        self.navigationItem.rightBarButtonItem = shareButton;
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    @objc func backButtonDidClicked() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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

extension DetailsViewController {
    @objc func shareButtonDidClicked(_ sender: UIButton) {
        let firstActivityItem = pageTitle + "\n"
        let secondActivityItem: URL = URL(string: postURL!)!
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.print,
            UIActivityType.addToReadingList
            
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}
