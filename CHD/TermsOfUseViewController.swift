//
//  TermsOfUseViewController.swift
//  CHD
//
//  Created by CenSoft on 30/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//


class TermsOfUseViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {

    let webView = UIWebView()
    var pageTitle = String()
    var pageURL = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = pageTitle

        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: pageTitle)

        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])

        view.backgroundColor = .white

        webView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        webView.delegate = self
        webView.scrollView.delegate = self
        webView.backgroundColor = UIColor.white
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        activityIndicator.center = webView.center
        activityIndicator.startAnimating()
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

