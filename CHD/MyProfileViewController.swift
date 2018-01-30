//
//  MyProfileViewController.swift
//  CHD
//
//  Created by CenSoft on 17/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//

import UIKit
import ReachabilitySwift

class MyProfileViewController: BaseViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!

    @IBOutlet weak var streetTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryTextfield: UITextField!
    @IBOutlet weak var zipTextfield: UITextField!
    @IBOutlet weak var chooseImageButton: UIButton!

    var keyboardIsShown = false
    let backButton = UIButton()
    let backView = UIView()
    var signOutButton: UIBarButtonItem?
    var favButton: UIBarButtonItem?
    var isFromGallary: Bool = false

    private lazy var loadingIndicator: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 210, height: 100)
        view.layer.cornerRadius = 6
        view.addSubview(activityIndicator)
        activityIndicator.color = .white
        activityIndicator.frame = CGRect(x: 20, y: view.frame.height / 2 - 15, width: 30, height: 30)
        activityIndicator.startAnimating()
        let label = UILabel()
        label.text = "Please wait..."
        label.textColor = .white
        label.frame = CGRect(x: 80, y: view.frame.height / 2 - 15, width: 150, height: 30)
        view.addSubview(label)
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()

    private lazy var snackBar: UIView = {
        let bar = UIView()
        bar.frame.size = CGSize(width: view.frame.width, height: 50)
        bar.backgroundColor = .black

        let tick = UIImageView()
        tick.image =  #imageLiteral(resourceName: "icons8-ok_filled")
        tick.frame = CGRect(x: 20, y: 16, width: 20, height: 20)
        bar.addSubview(tick)

        let label = UILabel()
        label.text = "Profile saved!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.frame = CGRect(x: 50, y: 16, width: 250, height: 20)
        bar.addSubview(label)
        return bar
    }()

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window = UIWindow()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        firstName.delegate = self
        lastName.delegate = self
        streetTextfield.delegate = self
        cityTextfield.delegate = self
        stateTextField.delegate = self
        countryTextfield.delegate = self
        zipTextfield.delegate = self

        backView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)

        backButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 20, width: 30, height: 30)
        backButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        backView.addSubview(backButton)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)

        let favoutiteButton = UIButton()
        favoutiteButton.setImage(#imageLiteral(resourceName: "icons8-heart-outline-100"), for: .normal)
        favoutiteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        favoutiteButton.addTarget(self, action: #selector(favButtonDidClicked), for: .touchUpInside)
        favButton = UIBarButtonItem(customView: favoutiteButton)

        let signOut = UIButton()
        signOut.setImage(#imageLiteral(resourceName: "icons8-export-100"), for: .normal)
        signOut.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        signOut.addTarget(self, action: #selector(signOutButtonDidClicked), for: .touchUpInside)
        signOutButton = UIBarButtonItem(customView: signOut)

        self.navigationItem.rightBarButtonItems = [signOutButton!, favButton!]
        addingObserverOnView()

        window = appDelegate.window!
        snackBar.frame.origin.y = window.frame.height
        snackBar.frame.origin.x = 0
        snackBar.frame.size.width = window.frame.width
        window.addSubview(snackBar)


    }



    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = image
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear



        if !isFromGallary {
            getUserData()
        }
    }

    @objc func favButtonDidClicked() {
        let vc = ChooseFavViewController()
        vc.isFromMyProfile = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func signOutButtonDidClicked() {
        print("sign out")
        UserDefaults.standard.set("", forKey: "userID")
        UserDefaults.standard.set(false, forKey: "isLoggedInSkipped")
//        UserDefaults.standard.set("", forKey: "fname")
//        UserDefaults.standard.set("", forKey: "lname")
//        //UserDefaults.standard.set(sex!, forKey: "gender")
//        UserDefaults.standard.set("", forKey: "dob")
//        UserDefaults.standard.set("", forKey: "street")
//        UserDefaults.standard.set("", forKey: "city")
//        UserDefaults.standard.set("", forKey: "state")
//        UserDefaults.standard.set("", forKey: "country")
//        UserDefaults.standard.set("", forKey: "zip")
//        UserDefaults.standard.set("", forKey: "timezone")
//        UserDefaults.standard.set("", forKey: "profileImage")
//
//        func resetDefaults() {
//            let defaults = UserDefaults.standard
//            let dictionary = defaults.dictionaryRepresentation()
//            dictionary.keys.forEach { key in
//                defaults.removeObject(forKey: key)
//            }
//        }
//        UserDefaults.standard.synchronize()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setupLoginNavigationController()

    }

    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func chooseImageButtonClicked(_ sender: UIButton) {
        print("Button clicked")
        self.isFromGallary = true
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary

        self.present(myPickerController, animated: true, completion: nil)
        
    }
    @IBAction func submitButtonDidClicked(_ sender: UIButton) {
        if validateAllFields() {
            DispatchQueue.main.async {
                self.loadingIndicator.alpha = 0.9
                self.loadingIndicator.center = self.view.center
                self.view.addSubview(self.loadingIndicator)
            }

            sendUserData(requestURL: ACCOUNT_SETTING_URL) { (dict) in
                //if let strongSelf = self {
                    print(dict["errorCode"] as! String)
                    DispatchQueue.main.async {
                        self.loadingIndicator.alpha = 0
                        UIView.animate(withDuration: 0.5, animations: {
                            self.snackBar.frame.origin.y = (self.window.frame.height) - 50
                        }, completion: nil)
                        UIView.animate(withDuration: 0.5, delay: 2.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                            self.snackBar.frame.origin.y = (self.window.frame.height) + 50
                        }, completion: nil)
                    }
                //}
            }
        } else {
            self.displayAlertView("All fields are compulsory", message: "Do not leave any field empty", handler: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])

    {
        let size = CGSize(width: 420, height: 225)
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        image = image?.resize(toTargetSize: size) // image?.crop(to: size)
        profileImage.image = image!

        self.dismiss(animated: true) {
            self.myImageUploadRequest()
            self.isFromGallary = false
        }
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    func sendUserData(requestURL: String, completion: @escaping(NSDictionary) -> ()) {



        var userID: String = ""
        if let userId: String = UserDefaults.standard.string(forKey: "userID") {
            userID = userId
        }
        let sex = gender.titleForSegment(at: gender.selectedSegmentIndex)
        let requestDict = ["user_id":userID,"first_name":firstName.text!,"last_name":lastName.text!,"gender":sex! ,"dob":"1988/12/04","street":streetTextfield.text!,"city":cityTextfield.text!,"state": stateTextField.text!,"country":countryTextfield.text!,"zip":zipTextfield.text!,"time_zone":"ASIA/COLOMBO"]
        
        HTTPAPICalling.sharedInstance.fetchAPIByRegularConvention(requestMethod: POST, requestURL: requestURL, requestParaDic: requestDict , completion: { (dict) in
            completion(dict!)

//            UserDefaults.standard.set(self.firstName.text!, forKey: "fname")
//            UserDefaults.standard.set(self.lastName.text!, forKey: "lname")
//            UserDefaults.standard.set(sex!, forKey: "gender")
//            UserDefaults.standard.set("1988/12/04", forKey: "dob")
//            UserDefaults.standard.set(self.streetTextfield.text!, forKey: "street")
//            UserDefaults.standard.set(self.cityTextfield.text!, forKey: "city")
//            UserDefaults.standard.set(self.stateTextField.text!, forKey: "state")
//            UserDefaults.standard.set(self.countryTextfield.text!, forKey: "country")
//            UserDefaults.standard.set(self.zipTextfield.text!, forKey: "zip")
//            UserDefaults.standard.set("ASIA/COLOMBO", forKey: "timezone")
//            UserDefaults.standard.synchronize()
        })
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        print("removed observers")
    }

}

extension MyProfileViewController {
    // MARK: - UIKeyBoardView methods
    @objc func keyboardWillShow(notification: NSNotification){
        if keyboardIsShown == false{
            if #available(iOS 11.0, *){
                guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}

                self.navigationController?.navigationBar.isHidden = true

                let height = view.frame.origin.y - keyboard.height + 80

                view.frame.origin.y =  height

                keyboardIsShown = true
            } else{
                guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return} // changed

                self.navigationController?.navigationBar.isHidden = true

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

                self.navigationController?.navigationBar.isHidden = false

                let height = view.frame.origin.y + keyboard.height - 80 //(view.frame.height) - keyboard.height
                view.frame.origin.y = height
                keyboardIsShown = false
            } else {
                guard let keyboard = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {return}

                self.navigationController?.navigationBar.isHidden = false

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

    func myImageUploadRequest()
    {

        let myUrl = NSURL(string: IMAGE_UPLOAD_URL);

        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";

        var userID: String = ""
        if let userId: String = UserDefaults.standard.string(forKey: "userID") {
            userID = userId
        }
        let param = [
            "user_id"    : userID
        ]

        let boundary = generateBoundaryString()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")


        var imageData = UIImageJPEGRepresentation(profileImage.image!, 1)

        var size = (((imageData?.count)! / 1024) / 1024)

        if size >= 3 {
            imageData = UIImageJPEGRepresentation(profileImage.image!, 0.5)
            size = (((imageData?.count)! / 1024) / 1024)

            if size >= 3
            {
                imageData = UIImageJPEGRepresentation(profileImage.image!, 0.2)
                size = (((imageData?.count)! / 1024) / 1024)

                if size >= 3
                { imageData = UIImageJPEGRepresentation(profileImage.image!, 0.1) }
            }
        }

        if(imageData==nil)  { return; }

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "user_profile", imageDataKey: imageData! as NSData, boundary: boundary) as Data

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

            if error != nil {
                print("error=\(error ?? "Error" as! Error)")
                return
            }

            // You can print out response object
            print("******* response = \(String(describing: response))")

            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                print(json ?? "Json")

//                DispatchQueue.main.async {
//                    let result: String = json!["result"] as! String
//                    UserDefaults.standard.set(result, forKey: "profileImage")
//                    UserDefaults.standard.synchronize()
//                }

            }catch
            {
                print(error)
            }

        }

        task.resume()
    }


    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();

        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }

        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"

        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")



        body.appendString(string: "--\(boundary)--\r\n")

        return body
    }

//    func setValueToTextFields() {
//            self.firstName.text = UserDefaults.standard.value(forKey: "fname") as? String
//            self.lastName.text = UserDefaults.standard.value(forKey: "lname") as? String
//            self.streetTextfield.text = UserDefaults.standard.value(forKey: "street") as? String
//            self.cityTextfield.text = UserDefaults.standard.value(forKey: "city") as? String
//            self.stateTextField.text = UserDefaults.standard.value(forKey: "state") as? String
//            self.countryTextfield.text = UserDefaults.standard.value(forKey: "country") as? String
//            self.zipTextfield.text = UserDefaults.standard.value(forKey: "zip") as? String
//            let link = UserDefaults.standard.value(forKey: "profileImage") as? String
//            if let url = URL(string: link!) {
//                self.profileImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
//            }
//            //self.lastName.text = UserDefaults.standard.value(forKey: "lname") as! String
//    }

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    func getUserData() {
        let reachability = Reachability()
        let status = reachability?.currentReachabilityStatus
        if status == .notReachable {
            print("No Internet")
        } else {
        DispatchQueue.main.async {
            self.loadingIndicator.center = self.view.center
            self.loadingIndicator.alpha = 0.9
            self.view.addSubview(self.loadingIndicator)
        }
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {return}

        //let url = URL(string: "http://uat.mobodesk.com/chd-api/api/?user_id=\(userID)")
        let url = URL(string: GET_USER_DATA_URL + "\(userID)")
        var request = URLRequest(url: url!)
        request.httpMethod = GET

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print("Error while fetching user data")
            } else {
                do {
                    guard let data = data else {return}
                    let parsedData = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    let errorCode: String = parsedData["errorCode"] as! String
                    if errorCode == "1" {
                        let result: NSDictionary = parsedData["result"] as! NSDictionary
                        let firstName: String = result["first_name"] as! String
                        let lastName: String = result["last_name"] as! String
                        let genderJSON: String = result["gender"] as! String
                        let _: String = result["dob"] as! String
                        let street: String = result["street"] as! String
                        let city: String = result["city"] as! String
                        let state: String = result["state"] as! String
                        let country: String = result["country"] as! String
                        let zip: String = result["zip"] as! String
                        let _: String = result["time_zone"] as! String
                        let imageURL: String = result["img_url"] as! String

                        DispatchQueue.main.async {
                            self.firstName.text = firstName
                            self.lastName.text = lastName
                            if genderJSON == "Male" {
                                self.gender.selectedSegmentIndex = 0
                            } else {
                                self.gender.selectedSegmentIndex = 1
                            }
                            self.streetTextfield.text = street
                            self.cityTextfield.text = city
                            self.stateTextField.text = state
                            self.countryTextfield.text = country
                            self.zipTextfield.text = zip
                            self.profileImage.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "user-placeholder"))
                            self.loadingIndicator.alpha = 0
                        }
                    }
                } catch {
                    print("catch block", error)
                }
            }
            }.resume()
    }
    }


}

extension NSMutableData {

    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension UIImage {

    func resize(toTargetSize targetSize: CGSize) -> UIImage? {

        let newScale = self.scale // change this if you want the output image to have a different scale
        let originalSize = self.size

        let widthRatio = targetSize.width / originalSize.width
        let heightRatio = targetSize.height / originalSize.height

        // Figure out what our orientation is, and use that to form the rectangle
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: floor(originalSize.width * heightRatio), height: floor(originalSize.height * heightRatio))
        } else {
            newSize = CGSize(width: floor(originalSize.width * widthRatio), height: floor(originalSize.height * widthRatio))
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)

        // Actually do the resizing to the rect using the ImageContext stuff
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = newScale
            format.opaque = true

            let newImage = UIGraphicsImageRenderer(bounds: rect, format: format).image() { _ in
                self.draw(in: rect)

            }
            return newImage
        } else {
            // Fallback on earlier versions
            return UIImage(named: "user-placeholder")
        }

    }
}

extension MyProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    func validateAllFields() -> Bool {
        if (firstName.text?.isEmpty)! || (lastName.text?.isEmpty)! || (streetTextfield.text?.isEmpty)! || (cityTextfield.text?.isEmpty)! || (stateTextField.text?.isEmpty)! || (countryTextfield.text?.isEmpty)! || (zipTextfield.text?.isEmpty)! {
            return false
        } else {
            return true
        }
    }
}

















