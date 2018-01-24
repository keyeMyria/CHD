
//
//  LeftViewController.swift
//  Slide
//
//  Created by Steve on 2017/8/1.
//  Copyright © 2017年 Jack. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {
    var tableView: UITableView!
    var items = ["Home", "Health Center", "Beauty & Skin Care", "Fitness", "Health Conditions", "Health News", "Reviews", "favourites"]
    var anotherItems = ["My Profile" ,"Advertise with Us", "Contact Us", "Terms of Use", "About Us", "Share This App"]
    var didselected: ((IndexPath, Int, Int) -> ())?

    var socialMediaView: UIStackView!
    var socialMediaViews: UIView!
    let anotherView = UIView()
    var isExpanded: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        //if APIManager.sharedInstance.isKeyPresentInUserDefaults(key: "userID") {
        if UserDefaults.standard.value(forKey: "userID") as! String == "" {
            anotherItems = ["Sign In" ,"Advertise with Us", "Contact Us", "Terms of Use", "About Us", "Share This App"]
        }

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        if UIDevice().userInterfaceIdiom == .pad {
            tableView.frame = CGRect(x: 0, y: 0, width: 220, height: view.frame.height)
        } else {
            tableView.frame = CGRect(x: 0, y: 0, width: 220, height: view.frame.height) //self.view.frame.width - 50
        }
        let headerView = UIView()
        if UIDevice().userInterfaceIdiom == .pad {
            headerView.frame = CGRect(origin: .zero, size: CGSize(width: 220 , height: 150))
        } else {
            headerView.frame = CGRect(origin: .zero, size: CGSize(width: 220, height: 150)) //view.frame.width - 50
        }
        headerView.backgroundColor = .white
        
        let logoView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        logoView.frame.size = CGSize(width: 100, height: 100)
        logoView.contentMode = .scaleAspectFit
        logoView.frame.origin.y = 10
        logoView.frame.origin.x = 60
        headerView.addSubview(logoView)

        let subTitleView = UIImageView(image: #imageLiteral(resourceName: "logo-title-tag"))
        subTitleView.frame.size = CGSize(width: 220, height: 30)
        subTitleView.contentMode = .scaleAspectFit
        subTitleView.frame.origin.y = 110
        subTitleView.frame.origin.x = 0
        headerView.addSubview(subTitleView)
        
//        let nameLabel = UILabel.init(frame: CGRect.init(x: 10, y: Int(headerView.frame.height - 40), width: Int(headerView.frame.size.width-20), height: 30))
//        nameLabel.text = "Consumer Health Digest"
//        nameLabel.textColor = UIColor.white
//        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        headerView.addSubview(nameLabel)
//
//        let tagLabel = UILabel.init(frame: CGRect.init(x: 10, y: Int(headerView.frame.height - 15) , width: Int(headerView.frame.size.width-20), height: 15))
//        tagLabel.text = "Your Trusted Source for Good Health"
//        tagLabel.textColor = UIColor.white
//        tagLabel.font = UIFont.italicSystemFont(ofSize: 12)
//        headerView.addSubview(tagLabel)

        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none
        tableView.bounces = false
        setupBottomView()
    }

    func startdismiss()  {
        self.dismiss(animated: false, completion: nil)
    }
   
    func setupBottomView() {
        let insta = UIButton()
        insta.backgroundColor = .white
        insta.setImage(#imageLiteral(resourceName: "icons8-instagram_new"), for: .normal)
        insta.tag = 0
        insta.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let fb = UIButton()
        fb.backgroundColor = .white
        fb.setImage(#imageLiteral(resourceName: "icons8-facebook"), for: .normal)
        fb.tag = 1
        fb.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let LI = UIButton()
        LI.backgroundColor = .white
        LI.setImage(#imageLiteral(resourceName: "icons8-linkedin"), for: .normal)
        LI.tag = 2
        LI.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let GPlus = UIButton()
        GPlus.backgroundColor = .white
        GPlus.setImage(#imageLiteral(resourceName: "icons8-google_plus_squared"), for: .normal)
        GPlus.tag = 3
        GPlus.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let twitter = UIButton()
        twitter.backgroundColor = .white
        twitter.setImage(#imageLiteral(resourceName: "icons8-twitter"), for: .normal)
        twitter.tag = 4
        twitter.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let pinterest = UIButton()
        pinterest.backgroundColor = .white
        pinterest.setImage(#imageLiteral(resourceName: "icons8-pinterest"), for: .normal)
        pinterest.tag = 5
        pinterest.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let youTube = UIButton()
        youTube.backgroundColor = .white
        youTube.setImage(#imageLiteral(resourceName: "icons8-youtube"), for: .normal)
        youTube.tag = 6
        youTube.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        

        socialMediaView = UIStackView(arrangedSubviews: [GPlus, fb, twitter,youTube,LI,insta, pinterest])
        socialMediaView.distribution = .fillEqually
        socialMediaView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30)
    }

    func setupBottomViews() {
        let insta = UIButton()
        insta.backgroundColor = .white
        insta.setImage(#imageLiteral(resourceName: "icons8-instagram_new"), for: .normal)
        insta.tag = 0
        insta.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let fb = UIButton()
        fb.backgroundColor = .white
        fb.setImage(#imageLiteral(resourceName: "icons8-facebook"), for: .normal)
        fb.tag = 1
        fb.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let LI = UIButton()
        LI.backgroundColor = .white
        LI.setImage(#imageLiteral(resourceName: "icons8-linkedin"), for: .normal)
        LI.tag = 2
        LI.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let GPlus = UIButton()
        GPlus.backgroundColor = .white
        GPlus.setImage(#imageLiteral(resourceName: "icons8-google_plus_squared"), for: .normal)
        GPlus.tag = 3
        GPlus.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let twitter = UIButton()
        twitter.backgroundColor = .white
        twitter.setImage(#imageLiteral(resourceName: "icons8-twitter"), for: .normal)
        twitter.tag = 4
        twitter.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let pinterest = UIButton()
        pinterest.backgroundColor = .white
        pinterest.setImage(#imageLiteral(resourceName: "icons8-pinterest"), for: .normal)
        pinterest.tag = 5
        pinterest.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)
        let youTube = UIButton()
        youTube.backgroundColor = .white
        youTube.setImage(#imageLiteral(resourceName: "icons8-youtube"), for: .normal)
        youTube.tag = 6
        youTube.addTarget(self, action: #selector(openSocialMediaView(_:)), for: .touchUpInside)

        let seeMore = UIButton()
        seeMore.backgroundColor = .white
        seeMore.setImage(#imageLiteral(resourceName: "icons8-plus-100"), for: .normal)
        seeMore.addTarget(self, action: #selector(expandSocialMediaView), for: .touchUpInside)

//        socialMediaView = UIStackView(arrangedSubviews: [GPlus, seeMore])
//        socialMediaView.backgroundColor = .blue
//        socialMediaView.distribution = .fillProportionally
//        socialMediaView.frame = CGRect(x: 0, y: 0, width: 10, height: 35)

        socialMediaViews = UIView()
        socialMediaViews.backgroundColor = .blue
        socialMediaViews.frame = CGRect(x: 0, y: 0, width: 50, height: 35)
        socialMediaViews.addSubview(anotherView)

        anotherView.backgroundColor = .red
        anotherView.frame = CGRect(x: 0, y: 0, width: 50, height: 35)
        anotherView.addSubview(GPlus)
        GPlus.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        anotherView.addSubview(seeMore)
        seeMore.frame = CGRect(x: 25, y: 0, width: 25, height: 25)


    }
    
    @objc func openSocialMediaView(_ sender: UIButton) {
        print(sender.tag)
       
        self.didselected?(IndexPath.init(row: -1, section: -1), -1,sender.tag)
        self.dismiss(animated: true, completion: nil)
    }

    @objc func expandSocialMediaView() {
        if !isExpanded {
            UIView.animate(withDuration: 0.5) {
                self.isExpanded = true
                self.anotherView.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.isExpanded = false
                self.anotherView.frame = CGRect(x: 0, y: 0, width: 50, height: 35)
            }
        }
    }
}

extension LeftViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        } else {
            return 2.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        } else {
            return 30.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        } else {
            let headerView = UIView()
            headerView.backgroundColor = .white
            let label = UILabel()
            label.backgroundColor = .lightGray
            label.frame = CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 1)
            headerView.addSubview(label)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        } else {
            tableView.tableFooterView?.backgroundColor = .white
            return socialMediaView
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return items.count
        } else {
            return anotherItems.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = indexPath.section == 0 ? items[indexPath.row] : anotherItems[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = item
        if indexPath.row == 7 {
            let plusButton = UIImageView(image: #imageLiteral(resourceName: "icons8-plus-100"))
            plusButton.frame.size = CGSize(width: 15, height: 15)
            cell.accessoryView = plusButton
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didselected?(indexPath, indexPath.section,-1)
        self.dismiss(animated: true, completion: nil)
    }
}


