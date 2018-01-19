//
//  MyProfileViewController.swift
//  CHD
//
//  Created by CenSoft on 17/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

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
    let signOut = UIButton(type: .system)


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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = image
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear

        backView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)

        backButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 20, width: 30, height: 30)
        backButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        backView.addSubview(backButton)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)


        signOut.setTitle("Sign out", for: .normal)
        signOut.setTitleColor(.white, for: .normal)
        signOut.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        signOut.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        signOut.addTarget(self, action: #selector(signOutButtonDidClicked), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOut)


        addingObserverOnView()
    }

    override func viewWillAppear(_ animated: Bool) {

        setValueToTextFields()
    }

    @objc func signOutButtonDidClicked() {
        print("sign out")
        UserDefaults.standard.set("", forKey: "userID")
        UserDefaults.standard.set(false, forKey: "isLoggedInSkipped")
        UserDefaults.standard.set("", forKey: "fname")
        UserDefaults.standard.set("", forKey: "lname")
        //UserDefaults.standard.set(sex!, forKey: "gender")
        UserDefaults.standard.set("", forKey: "dob")
        UserDefaults.standard.set("", forKey: "street")
        UserDefaults.standard.set("", forKey: "city")
        UserDefaults.standard.set("", forKey: "state")
        UserDefaults.standard.set("", forKey: "country")
        UserDefaults.standard.set("", forKey: "zip")
        UserDefaults.standard.set("", forKey: "timezone")
        UserDefaults.standard.set("", forKey: "profileImage")

        func resetDefaults() {
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
        }



        UserDefaults.standard.synchronize()
        UserDefaults.standard.synchronize()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setupLoginNavigationController()

    }

    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func chooseImageButtonClicked(_ sender: UIButton) {
        print("Button clicked")
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary

        self.present(myPickerController, animated: true, completion: nil)
        
    }
    @IBAction func submitButtonDidClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.loadingIndicator.alpha = 0.9
            self.loadingIndicator.center = self.view.center
            self.view.addSubview(self.loadingIndicator)
        }

        sendUserData(requestURL: ACCOUNT_SETTING_URL) { [weak self] (dict) in
            if let strongSelf = self {
                print(dict["errorCode"] as! String)
                DispatchQueue.main.async {
                    strongSelf.loadingIndicator.alpha = 0
                }
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])

    {
        let size = CGSize(width: 420, height: 225)
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        image = image?.crop(to: size)
        profileImage.image = image!

        self.dismiss(animated: true) {
            self.myImageUploadRequest()
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
            UserDefaults.standard.set(self.firstName.text!, forKey: "fname")
            UserDefaults.standard.set(self.lastName.text!, forKey: "lname")
            UserDefaults.standard.set(sex!, forKey: "gender")
            UserDefaults.standard.set("1988/12/04", forKey: "dob")
            UserDefaults.standard.set(self.streetTextfield.text!, forKey: "street")
            UserDefaults.standard.set(self.cityTextfield.text!, forKey: "city")
            UserDefaults.standard.set(self.stateTextField.text!, forKey: "state")
            UserDefaults.standard.set(self.countryTextfield.text!, forKey: "country")
            UserDefaults.standard.set(self.zipTextfield.text!, forKey: "zip")
            UserDefaults.standard.set("ASIA/COLOMBO", forKey: "timezone")
            UserDefaults.standard.synchronize()
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

                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.setHidesBackButton(true, animated: true)

                let height = view.frame.origin.y - keyboard.height + 80

                view.frame.origin.y =  height

                keyboardIsShown = true
            } else{
                guard let keyboard = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {return}

                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.rightBarButtonItem = nil
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
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOut)

                let height = view.frame.origin.y + keyboard.height - 80 //(view.frame.height) - keyboard.height
                view.frame.origin.y = height
                keyboardIsShown = false
            } else {
                guard let keyboard = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {return}

                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOut)

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

        let myUrl = NSURL(string: "http://uat.mobodesk.com/chd-api/api/?page=user_profile");
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");

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


        // myActivityIndicator.startAnimating();

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

                DispatchQueue.main.async {
                    let result: String = json!["result"] as! String
                    UserDefaults.standard.set(result, forKey: "profileImage")
                    UserDefaults.standard.synchronize()
                }

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

    func setValueToTextFields() {
        if APIManager.sharedInstance.isKeyPresentInUserDefaults(key: "fname") {
            self.firstName.text = UserDefaults.standard.value(forKey: "fname") as? String
            self.lastName.text = UserDefaults.standard.value(forKey: "lname") as? String
            self.streetTextfield.text = UserDefaults.standard.value(forKey: "street") as? String
            self.cityTextfield.text = UserDefaults.standard.value(forKey: "city") as? String
            self.stateTextField.text = UserDefaults.standard.value(forKey: "state") as? String
            self.countryTextfield.text = UserDefaults.standard.value(forKey: "country") as? String
            self.zipTextfield.text = UserDefaults.standard.value(forKey: "zip") as? String
            let link = UserDefaults.standard.value(forKey: "profileImage") as? String
            if let url = URL(string: link!) {
                self.profileImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "drawerImage"))
            }
            //self.lastName.text = UserDefaults.standard.value(forKey: "lname") as! String
        }
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    /*func getUserData() {
        DispatchQueue.main.async {
            self.loadingIndicator.center = self.view.center
            self.loadingIndicator.alpha = 0.9
            self.view.addSubview(self.loadingIndicator)
        }
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {return}

        let url = URL(string: "http://uat.mobodesk.com/chd-api/api/?user_id=\(userID)")
        var request = URLRequest(url: url!)
        request.httpMethod = GET

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print("Error while fetching user data")
            } else {
                do {
                    guard let data = data else {return}
                    let parsedData = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    //                    let result: NSDictionary = parsedData["result"] as! NSDictionary
                    //                    let firstName: String = result["first_name"] as! String
                    //                    let lastName: String = result["last_name"] as! String
                    //                    let gender: String = result["gender"] as! String
                    //                    "dob"
                    //                    "street"
                    //                    "city"
                    //                    "state"
                    //                    "country"
                    //                    "zip"
                    //                    "time_zone": "ASIA/COLOMBO",
                    //                    "img_url"

                    DispatchQueue.main.async {
                        self.firstName.text = firstName
                        self.lastName.text = lastName
                        if
                            self.gender.selectedSegmentIndex = 0
                        self.loadingIndicator.alpha = 0
                    }
                } catch {
                    print("catch block", error)
                }
            }
            }.resume()
    }*/



}

extension NSMutableData {

    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension UIImage {

    func crop(to:CGSize) -> UIImage {
        guard let cgimage = self.cgImage else { return self }

        let contextImage: UIImage =  UIImage.init(cgImage: cgimage) //UIImage(CGImage: cgimage)

        let contextSize: CGSize = contextImage.size

        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height

        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height

        if to.width > to.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if to.width < to.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = ((contextImage.cgImage)?.cropping(to: rect))! //CGImageCreateWithImageInRect(contextImage.cgImage!, rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage.init(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        UIGraphicsBeginImageContextWithOptions(to, true, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized!
    }
}
