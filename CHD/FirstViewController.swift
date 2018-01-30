 //
//  ViewController.swift
//  tabView
//
//  Created by CenSoft on 27/11/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit
import SideNavigation
import SDWebImage

var dateFormatter: DateFormatter = {
    let df = DateFormatter()
    return df
}()



class FirstViewController: UITableViewController {
    var leftViewController: LeftViewController! {
        didSet {
            self.slideMenuManager1 = SideMenuManager(self, left: self.leftViewController)
        }
    }
    
    var slideMenuManager1: SideMenuManager!
    var array:[PostData] = []
    var pageCount = 20
    
    var url: String?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window = UIWindow()
    
    var backGroundView: UIView!
    var shareView: UIView!

    private lazy var snackBar: UIView = {
        let bar = UIView()
        bar.frame.size = CGSize(width: view.frame.width, height: 50)
        bar.backgroundColor = .black

        let tick = UIImageView()
        tick.image = #imageLiteral(resourceName: "icons8-ok_filled")
        tick.frame = CGRect(x: 20, y: 16, width: 20, height: 20)
        bar.addSubview(tick)

        let label = UILabel()
        label.text = "Saved to Favourite!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.frame = CGRect(x: 50, y: 16, width: 250, height: 20)
        bar.addSubview(label)
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Home"
        
        window = (appDelegate.window)!

        snackBar.frame.origin.y = window.frame.height
        snackBar.frame.origin.x = 0
        window.addSubview(snackBar)

        if UserDefaults.standard.bool(forKey: "showSnackBar") {
            UserDefaults.standard.set(false, forKey: "showSnackBar")
            UIView.animate(withDuration: 0.5, animations: {
                self.snackBar.frame.origin.y = self.window.frame.height - 50

            })
            UIView.animate(withDuration: 0.5, delay: 2.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.snackBar.frame.origin.y = self.window.frame.height + 50
            }, completion: nil)
        }

        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Home - Recent Post")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        tableView.rowHeight = 50
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "LoadingCell", bundle: Bundle.main), forCellReuseIdentifier: "loading")

        self.leftViewController = LeftViewController()
        self.leftViewController.didselected = { [weak self]  (indexPath, section, tag) in
            if let strongSelf = self {
                if (tag != -1)
                {
                    switch tag {
                    case 0:
                        strongSelf.url = "https://www.instagram.com/consumerhealthdigest/"
                    case 1:
                        strongSelf.url = "https://www.facebook.com/ConsumerHealthDigest"
                    case 2:
                        strongSelf.url = "https://www.linkedin.com/company/consumer-health-digest/"
                    case 3:
                        strongSelf.url = "https://plus.google.com/+ConsumerHealthDigest"
                    case 4:
                        strongSelf.url = "https://twitter.com/ConsumerHDigest#"
                    case 5:
                        strongSelf.url = "https://in.pinterest.com/ConsmerHDigest/"
                    case 6:
                        strongSelf.url = "https://www.youtube.com/user/ConsumerHealthDigest"
                    default:
                        print("default")
                    }
                    
                    if strongSelf.verifyUrl(urlString: strongSelf.url){
                        UIApplication.shared.openURL(URL(string: strongSelf.url!)!)
                    }
                } else {
                    switch section {
                        
                    case 0:
                        switch indexPath.row{
                        case 0:
                            print("Home")
                            strongSelf.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                        case 1:
                            print("Health center")
                            let fitnessVC = HealthCenterViewController()
                            fitnessVC.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(fitnessVC, animated: true)
                        case 2:
                            print("Beauty & skin care")
                            let fitnessVC = FitnessViewController()
                            fitnessVC.pageTitle = "Beauty & Skin Care"
                            fitnessVC.APIReference = "beauty-skin-care"
                            fitnessVC.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(fitnessVC, animated: true)
                        case 3:
                            print("Fitness")
                            let fitnessVC = FitnessViewController()
                            fitnessVC.pageTitle = "Fitness"
                            fitnessVC.APIReference = "fitness"
                            fitnessVC.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(fitnessVC, animated: true)
                        case 4:
                            print("Health conditions")
                            let healthConditionVC = HealthConditionViewController()
                            healthConditionVC.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(healthConditionVC, animated: true)
                        case 5:
                            print("Health News")
                            let fitnessVC = FitnessViewController()
                            fitnessVC.pageTitle = "Health News"
                            fitnessVC.APIReference = "health-news"
                            fitnessVC.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(fitnessVC, animated: true)
                        case 6:
                            print("Reviews review")
                            let reviewVC = ReviewTableViewController()
                            reviewVC.pageTitle = "Reviews"
                            reviewVC.APIReference = "review"
                            reviewVC.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(reviewVC, animated: true)
                        case 7:
                            print("Favourites")
                            let favVC = ChooseFavViewController()
                            favVC.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(favVC, animated: true)
                        default:
                            print("bello")
                        }
                        break
                    case 1:
                        switch indexPath.row{
                        case 0:
                            print("My profile")
                            //if APIManager.sharedInstance.isKeyPresentInUserDefaults(key: "userID") {
                            if UserDefaults.standard.value(forKey: "userID") as! String != "" {
                                let vc = MyProfileViewController()
                                vc.hidesBottomBarWhenPushed = true
                                strongSelf.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                let vc = LoginViewController()
                                vc.hidesBottomBarWhenPushed = true
                                strongSelf.navigationController?.pushViewController(vc, animated: true)
                            }
                            break
                        case 1:
                            print("Advertise with Us")
                            let aboutUs = AdvertWithUsViewController()
                            aboutUs.pageTitle = "Advertise with Us"
                            aboutUs.pageURL = ADVERTISE_WITH_US_URL
                            aboutUs.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(aboutUs, animated: true)
                            break
                        case 2:
                            print("Contact Us")
                            let aboutUs = ContactUsViewController()
                            aboutUs.pageTitle = "Contact Us"
                            aboutUs.pageURL = CONTACT_US_URL
                            aboutUs.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(aboutUs, animated: true)
                            break
                        case 3:
                            print("Terms of Use")
                            let aboutUs = TermsOfUseViewController()
                            aboutUs.pageTitle = "Terms of Use"
                            aboutUs.pageURL = TERMS_OF_USE_URL
                            aboutUs.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(aboutUs, animated: true)
                            break
                        case 4:
                            print("About Us")
                            let aboutUs = AboutUsViewController()
                            aboutUs.pageTitle = "About Us"
                            aboutUs.pageURL = ABOUT_US_URL
                            aboutUs.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(aboutUs, animated: true)
                            break
                        case 5:
                            print("Share app")
                            strongSelf.backGroundView = {
                                let backView = UIView()
                                backView.frame = CGRect(x: 0, y: 0, width: strongSelf.window.frame.width, height: strongSelf.window.frame.height)
                                backView.backgroundColor = .black
                                backView.alpha = 0.7
                                return backView
                            }()
                            strongSelf.shareView = {
                                let dilogView = UIView()
                                dilogView.frame = CGRect(x: 10, y: (strongSelf.view.frame.height / 2) - 80, width: strongSelf.view.frame.width - 20, height: 160)
                                dilogView.backgroundColor = .white
                                dilogView.layer.cornerRadius = 6
                                dilogView.clipsToBounds = true
                                
                                let androidShare = UIButton()
                                androidShare.setImage(#imageLiteral(resourceName: "play store"), for: .normal)
                                androidShare.imageView?.contentMode = .scaleAspectFit
                                androidShare.addTarget(self, action: #selector(strongSelf.playStoreButtonDidClicked), for: .touchUpInside)
                                
                                let iOSShare = UIButton()
                                iOSShare.setImage(#imageLiteral(resourceName: "app store"), for: .normal)
                                iOSShare.addTarget(self, action: #selector(strongSelf.appStoreButtonDidClicked), for: .touchUpInside)
                                
                                let stackView = UIStackView(arrangedSubviews: [iOSShare, androidShare])
                                stackView.distribution = .fillEqually
                                stackView.frame = CGRect(x: 10, y: 10, width: dilogView.frame.width - 20, height: 50)
                                dilogView.addSubview(stackView)
                                
                                let appStore = UIButton()
                                appStore.setTitle("App Store", for: .normal)
                                appStore.setTitleColor(.black, for: .normal)
                                appStore.addTarget(self, action: #selector(strongSelf.appStoreButtonDidClicked), for: .touchUpInside)
                                
                                let playStore = UIButton()
                                playStore.setTitle("Play Store", for: .normal)
                                playStore.setTitleColor(.black, for: .normal)
                                playStore.addTarget(self, action: #selector(strongSelf.playStoreButtonDidClicked), for: .touchUpInside)
                                
                                
                                let labelStackView = UIStackView(arrangedSubviews: [appStore, playStore])
                                labelStackView.distribution = .fillEqually
                                labelStackView.frame = CGRect(x: 10, y: 70, width: dilogView.frame.width - 20, height: 20)
                                dilogView.addSubview(labelStackView)
                                
                                let cancelButton = UIButton()
                                cancelButton.setTitle("Cancel", for: .normal)
                                cancelButton.setTitleColor(.black, for: .normal)
                                cancelButton.frame = CGRect(x: 10, y: 110, width: dilogView.frame.width - 20, height: 40)
                                cancelButton.layer.borderWidth = 1
                                cancelButton.layer.cornerRadius = 6
                                cancelButton.clipsToBounds = true
                                cancelButton.addTarget(self, action: #selector(strongSelf.removeDilogViewFromSuperView), for: .touchUpInside)
                                dilogView.addSubview(cancelButton)
                                
                                
                                return dilogView
                            }()
                            DispatchQueue.main.async{
                                strongSelf.window.addSubview(strongSelf.backGroundView)
                                strongSelf.window.addSubview(strongSelf.shareView)
                            }
                        default:
                            print("Hello")
                        }
                    default:
                        print("default")
                    }
                }
            }
            
        }
        
        APIManager.sharedInstance.delegate = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let url = NSURL(string: urlString!) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    @objc func removeDilogViewFromSuperView() {
        DispatchQueue.main.async {
            self.shareView.removeFromSuperview()
            self.backGroundView.removeFromSuperview()
        }
    }
    
    @objc func appStoreButtonDidClicked(_ sender: UIButton) {
        removeDilogViewFromSuperView()
        let firstActivityItem = "Consumer Health Digest App \n"
        let secondActivityItem: URL = URL(string: "http://google.com")!
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
    
    @objc func playStoreButtonDidClicked(_ sender: UIButton) {
        removeDilogViewFromSuperView()
        let firstActivityItem = "Consumer Health Digest App \n"
        let secondActivityItem: URL = URL(string: "http://google.com")!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.backIndicatorImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = nil
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated:true);
        if #available (iOS 11.0, *){
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        let imageView = UIImageView(image:#imageLiteral(resourceName: "logo"))
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageView.contentMode = .scaleAspectFit
        let logoButton = UIBarButtonItem(customView: imageView)
        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(openDrawer))
        self.navigationItem.leftBarButtonItems = [menuButton, logoButton]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-search"), style: .plain, target: self, action: #selector(searchButtonDidClicked))
        
        APIFailuareHandler()
    }

    override func viewDidAppear(_ animated: Bool) {
        registerDeviceForPushNotification()
    }

    func registerDeviceForPushNotification() {
        if !(UserDefaults.standard.bool(forKey: "deviceRegistered")) {
            APIManager.sharedInstance.registerDevice(requestURL: REGISTER_DEVICE_URL) { (dict) in
                
                let errorcode = dict.value(forKey: "errorCode") as! String
                if errorcode == "1"
                {
                   UserDefaults.standard.set(true, forKey: "deviceRegistered")
                }
                
                
                print("Device is registered for push notification")
            }
            // add call for http://uat.mobodesk.com/chd-api/api/?page=registered_device
        }
    }
    
    //// TableView datasoure and delegate
    
    @objc func searchButtonDidClicked() {
        print("Search button did clicked")
        let searchVC = SearchTableViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func openDrawer() {
        self.present(self.leftViewController, animated: true, completion: nil)
    }
}

extension FirstViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if APIManager.sharedInstance.isLoadingIndexPath(indexPath) {
            
            return 50
            
        } else {
            if UIDevice().userInterfaceIdiom == .pad {
                return 400.0
            } else {
                return 250.0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return array.count
        return APIManager.sharedInstance.numberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if APIManager.sharedInstance.isLoadingIndexPath(indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loading") as! LoadingCell
            
            cell.activityIndicator.startAnimating()
            
            
            return cell
        } else {
            guard let post = APIManager.sharedInstance.cellForRow(at: indexPath, tableView: tableView) else {return UITableViewCell()}
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
        
        let post = APIManager.sharedInstance.didSelectRow(at: indexPath)
        
        let postURL = post?.post_title_url
        let postTitle = post?.post_title
        let vc = DetailsViewController()
        vc.pageTitle = postTitle!
        vc.postURL = postURL!
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FirstViewController {
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

extension FirstViewController {
    func APIFailuareHandler() {
        if array.count == 0 {
            APIManager.sharedInstance.getResentPostsData(pageCount: 1, completion: {
                
            })
        }
    }
//
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        if(velocity.y>0) {
//            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
//            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
//                self.tabBarController?.tabBar.isHidden = true
//                print("Hide")
//            }, completion: nil)
//
//        } else {
//            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                self.tabBarController?.tabBar.isHidden = false
//                print("Unhide")
//            }, completion: nil)
//        }
//    }
}

