//
//  MyProfileViewController.swift
//  CHD
//
//  Created by CenSoft on 17/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!

    @IBOutlet weak var streetTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var countryTextfield: UITextField!
    @IBOutlet weak var zipTextfield: UITextField!

    var keyboardIsShown = false
    let backButton = UIButton()
    let backView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear


        backView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)


        backButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 20, width: 30, height: 30)
        backButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        backView.addSubview(backButton)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)

        addingObserverOnView()
    }

    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
        //sendUserData(requestURL: ACCOUNT_SETTING_URL) { (dict) in
        //    print(dict)
        //}
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    func sendUserData(requestURL: String, completion: @escaping(NSDictionary) -> ()) {
        let requestDict = ["user_id":"",
                           "platform":"0",
                           "user_id":"",
                           "reference":"pushnotification"]
        HTTPAPICalling.sharedInstance.fetchAPIByRegularConvention(requestMethod: POST, requestURL: requestURL, requestParaDic: requestDict , completion: { (dict) in
            completion(dict!)
        })
    }

}

extension MyProfileViewController {
    // MARK: - UIKeyBoardView methods
    @objc func keyboardWillShow(notification: NSNotification){
        if keyboardIsShown == false{
            if #available(iOS 11.0, *){
                guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}

                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.setHidesBackButton(true, animated: true)

                let height = view.frame.origin.y - keyboard.height + 80

                view.frame.origin.y =  height

                keyboardIsShown = true
            } else{
                guard let keyboard = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {return}

                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.setHidesBackButton(true, animated: true)

                let height = view.frame.origin.y - keyboard.height + 80

                view.frame.origin.y =  height

                keyboardIsShown = true
            }
        } else{
            print("not again")
        }
    }

    @objc func keyboardWillHide(notification: NSNotification){
        if keyboardIsShown{
            if #available(iOS 11.0, *){
                guard let keyboard = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {return}

                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)
                

                let height = view.frame.origin.y + keyboard.height - 80 //(view.frame.height) - keyboard.height
                view.frame.origin.y = height
                keyboardIsShown = false
            } else {
                guard let keyboard = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {return}

                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)

                let height = view.frame.origin.y + keyboard.height - 80 //(view.frame.height) - keyboard.height
                view.frame.origin.y = height
                keyboardIsShown = false
            }

        } else {
            print("again")
        }
    }

    func addingObserverOnView(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

}
