//
//  ViewController.swift
//  CollectionViewTutorial
//
//  Created by James Rochabrun on 12/13/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

struct Model {
    var title: String?
    var category: Int?
}

class ChooseFavViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var gridCollectionView: UICollectionView!
    var gridLayout: GridLayout!
    var fullImageView: UIImageView!
    
    let innerSpace: CGFloat = 5.0
    let numberOfCellsOnRow: CGFloat = 3

    var pageCount = 1
    var array = [Model]()
    var favArray = [Int]()
    var shouldShowLoadingCell = true
    var APIReference = "health_center"
    var pageTitle = "Welcome to CHD"
    var subTitle = "Follow Topics"

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = pageTitle
        self.navigationItem.titleView = setTitle(title: pageTitle, subtitle: subTitle)

        self.navigationController?.navigationBar.shadowImage = UIImage()

        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: pageTitle)

        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        // Do any additional setup after loading the view, typically from a nib.
        gridLayout = GridLayout()
        gridCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: gridLayout)
        gridCollectionView.backgroundColor = UIColor.white
        gridCollectionView.showsVerticalScrollIndicator = false
        gridCollectionView.showsHorizontalScrollIndicator = false
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        gridCollectionView!.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(gridCollectionView)

        fullImageView = UIImageView()
        fullImageView.contentMode = .scaleAspectFit
        fullImageView.backgroundColor = UIColor.lightGray
        fullImageView.isUserInteractionEnabled = true
        fullImageView.alpha = 0
        self.view.addSubview(fullImageView)

        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        apiCallingFunction()

    }

    fileprivate func apiCallingFunction() {
        APIManager.sharedInstance.getReviewData(pageCount: pageCount, reference: APIReference) { (dict) in
            guard let dictionary = dict else {return}
            let data = dictionary["data"] as! NSDictionary

            let beautySkinCare = data["Beauty_Skin_Care"] as! [NSDictionary]
            let menHealth = data["Mens_Health"] as! [NSDictionary]
            let womenHealth = data["Women_Health"] as! [NSDictionary]
            let generalHealth = data["General_Health"] as! [NSDictionary]
            for i in beautySkinCare {
                let pageTitle = i["post_title"] as! String
                let category = i["cat_id"] as! Int
                print(pageTitle)

                self.array.append(Model(title: pageTitle, category: category))
            }
            for i in menHealth {
                let pageTitle = i["post_title"] as! String
                let category = i["cat_id"] as! Int
                print(pageTitle)

                self.array.append(Model(title: pageTitle, category: category))
            }
            for i in womenHealth {
                let pageTitle = i["post_title"] as! String
                let category = i["cat_id"] as! Int
                print(pageTitle)

                self.array.append(Model(title: pageTitle, category: category))
            }
            for i in generalHealth {
                let pageTitle = i["post_title"] as! String
                let category = i["cat_id"] as! Int
                print(pageTitle)

                self.array.append(Model(title: pageTitle, category: category))
            }
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                self.gridCollectionView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = image
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.white

        let nextView = UIView()
        nextView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)

        let nextButton = UIButton()
        nextButton.setImage(#imageLiteral(resourceName: "icons8-right-filled-50"), for: .normal)
        nextButton.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
        nextButton.addTarget(self, action: #selector(doneButtonDidClicked), for: .touchUpInside)
        nextView.addSubview(nextButton)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextView)

        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    @objc func doneButtonDidClicked() {
        print("done")
        var userID: String = ""
        if APIManager.sharedInstance.isKeyPresentInUserDefaults(key: "userID") {
            userID = UserDefaults.standard.value(forKey: "userID") as! String

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
        } else {
            DispatchQueue.main.async {
                UserDefaults.standard.set("", forKey: "userID")
                UserDefaults.standard.set(self.favArray, forKey: "category")
                self.appDelegate.setupTabBarController()
                let vc = FirstViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var frame = gridCollectionView.frame
        frame.size.height = self.view.frame.size.height
        frame.size.width = self.view.frame.size.width
        frame.origin.x = 0
        frame.origin.y = 0
        gridCollectionView.frame = frame
        fullImageView.frame = gridCollectionView.frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ChooseFavViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        let post = array[indexPath.row]
        cell.imageView.image = UIImage.init(named: "eye")
        cell.label.text = post.title!

        if favArray.contains(post.category!) {
            cell.checkView.alpha = 1
        } else {
            cell.checkView.alpha = 0

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        let post = array[indexPath.row]

        if cell.checkView.alpha == 0 {
            someMethodToCall(category: post.category!)
            cell.checkView.alpha = 1
            print(favArray)
        } else {
            favArray = favArray.filter{$0 != post.category!}
            cell.checkView.alpha = 0
            print(favArray)
        }
    }

    func someMethodToCall(category: Int) {
        print(category)
        favArray.append(category)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                print("Hide")
            }, completion: nil)

        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                print("Unhide")
            }, completion: nil)
        }
    }
    
}

extension ChooseFavViewController {
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))

        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 15)//.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width

        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }

        return titleView
    }
}










