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

class SecondViewController: UITableViewController {
    var leftViewController: LeftViewController! {
        didSet {
            self.slideMenuManager1 = SideMenuManager(self, left: self.leftViewController)
        }
    }
    
    var count = 1
    var array:[PostData] = []
    var shouldShowLoadingCell = true
    var url: String?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window = UIWindow()
    
    var backGroundView: UIView!
    var shareView: UIView!
    
    static let APIReference = "health-news"
    
    var slideMenuManager1: SideMenuManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "News"
        
        window = (appDelegate.window)!
        
        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "News - Breaking News")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        if #available (iOS 11.0, *){
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
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
                            strongSelf.tabBarController?.selectedIndex = 0
                            strongSelf.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                        case 1:
                            print("Health center")
                            let fitnessVC = HealthCenterViewController()
                            fitnessVC.hidesBottomBarWhenPushed = true
                            strongSelf.navigationController?.pushViewController(fitnessVC, animated: true)
                        case 2:
                            print("Beauty & skin care")
                            let fitnessVC = FitnessViewController()
                            fitnessVC.pageTitle = "Beauty & skin care"
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
                        default:
                            print("bello")
                        }
                        break
                    case 1:
                        switch indexPath.row{
                        case 0:
                            print("My profile")
                            if APIManager.sharedInstance.isKeyPresentInUserDefaults(key: "userID") {
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
                            let aboutUs = AboutUsViewController()
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
        
        fetchData()
        
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let url = NSURL(string: urlString!) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    func fetchData() {
        APIManager.sharedInstance.getFitnessData(pageCount: count, reference: SecondViewController.APIReference) { [weak self] (array, pageCount) in
            if let strongSelf = self {
                if (strongSelf.count) < pageCount {
                    strongSelf.shouldShowLoadingCell = true
                } else {
                    strongSelf.shouldShowLoadingCell = false
                }
                for i in 0..<array.count{
                    strongSelf.array.append(array[i])
                }
                print(array.count)
                strongSelf.count += 1
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
        }
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
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backIndicatorImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = nil

        let imageView = UIImageView(image:#imageLiteral(resourceName: "logo"))
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageView.contentMode = .scaleAspectFit
        let logoButton = UIBarButtonItem(customView: imageView)
        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(leftClick))
        self.navigationItem.leftBarButtonItems = [menuButton, logoButton]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-search"), style: .plain, target: self, action: #selector(searchButtonDidClicked))
    }
    
    //// TableView datasoure and delegate
    
    @objc func searchButtonDidClicked() {
        print("Search button did clicked")
        let searchVC = SearchTableViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func leftClick() {
        self.present(self.leftViewController, animated: true, completion: nil)
    }
}

extension SecondViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoadingIndexPath(indexPath) {
            return 50.0
        } else {
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

extension SecondViewController {
    func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else {return false}
        return indexPath.row == self.array.count
    }
}

extension SecondViewController {
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

