//
//  LoginViewController.swift
//  CHD
//
//  Created by CenSoft on 11/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//

import UIKit

struct Result: Decodable {
    var errorCode: String?
    var user_id: Int?
    var result: UserCredintial?
}

struct UserCredintial: Decodable {
    var user_id: String?
    var user_name: String?
    var user_email: String?
    var first_name: String?
    var last_name: String?
    var user_token: String?
    var user_status: String?
}

class CustomTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

class LoginViewController: BaseViewController {

    var keyboardIsShown = false
    
    class var sharedInstance :LoginViewController {
        struct Singleton {
            static let instance = LoginViewController()
        }
        
        return Singleton.instance
    }
    
    private lazy var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var topLogoView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var skipButton: UIButton = {
        var button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    
    private lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "collage")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var titleView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "welcome")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "E-mail"
        let imageView = UIImageView(image: #imageLiteral(resourceName: "username"))
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        textField.leftViewMode = .always
        textField.leftView = imageView
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.backgroundColor = .white
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Login Password or Create a Password"
        let imageView = UIImageView(image: #imageLiteral(resourceName: "password"))
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        textField.leftViewMode = .always
        textField.leftView = imageView
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.backgroundColor = .white
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "sign-in"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.isEnabled = false
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "forgot-pass"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private lazy var socialMedia: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var facebook: UIImageView = {
        let firstView = UIImageView()
        firstView.image = #imageLiteral(resourceName: "fb-logo")
        return firstView
    }()
    
    private lazy var google: UIImageView = {
        let firstView = UIImageView()
        firstView.image = #imageLiteral(resourceName: "g+-logo")
        firstView.contentMode = .scaleAspectFill
        return firstView
    }()

    private lazy var continueWithLabel: UILabel = {
        let label = UILabel()
        label.text = "Continue with"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()

    private lazy var underline1: UILabel = {
        let secondView = UILabel()
        secondView.backgroundColor = .lightGray
        return secondView
    }()

    private lazy var underline2: UILabel = {
        let secondView = UILabel()
        secondView.backgroundColor = .lightGray
        return secondView
    }()

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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundImage()
        setupTopView()
        addEmailTextField()
        addPasswordTextField()
        addLoginButton()
        addForgotPasswordButton()
        addConstraintsToSkipButton()
        addingObserverOnView()
        //addDivider()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    fileprivate func setupTopView() {
        self.blurView.addSubview(containerView)
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        self.containerView.addSubview(topLogoView)
        topLogoView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: self.view.frame.height / 2 + 200)

        topLogoView.addSubview(logoView)
        logoView.frame = CGRect(x: 0, y: 0, width: topLogoView.frame.width, height: topLogoView.frame.height / 2)

        topLogoView.addSubview(titleView)
        let width = topLogoView.frame.width
        titleView.frame = CGRect(x: 30, y: logoView.frame.height , width: width - 60, height: 100)

        containerView.addSubview(socialMedia)
        socialMedia.frame = CGRect(x: 0, y: topLogoView.frame.height, width: view.frame.width, height: view.frame.height - topLogoView.frame.height)

        socialMedia.addSubview(continueWithLabel)
        continueWithLabel.frame = CGRect(x: socialMedia.frame.width / 2 - 115, y: 20, width: 90, height: 10)
        socialMedia.addSubview(facebook)
        facebook.frame = CGRect(x: continueWithLabel.frame.origin.x + 90, y: 0, width: 50, height: 50)
        socialMedia.addSubview(google)
        google.frame = CGRect(x: facebook.frame.origin.x + 60, y: 0, width: 50, height: 50)

    }
    
    func addConstraintsToSkipButton() {
        self.socialMedia.addSubview(skipButton)
        skipButton.addTarget(self, action: #selector(skipLogin), for: .touchUpInside)
        if #available(iOS 11.0, *) {
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
            skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        } else {
            // Fallback on earlier versions
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        }
    }
    
    fileprivate func addBackgroundImage() {
        self.view.addSubview(blurView)
        blurView.frame = self.view.frame
    }
    
    fileprivate func addEmailTextField() {
        emailTextField.delegate = self
        let width = topLogoView.frame.width
        self.topLogoView.addSubview(emailTextField)
        emailTextField.frame = CGRect(x: 30, y: logoView.frame.height + titleView.frame.height , width: width - 60 , height: 30)
        self.topLogoView.addSubview(underline1)
        underline1.frame = CGRect(x: 30, y: emailTextField.frame.origin.y + emailTextField.frame.height, width: width - 60, height: 1)
    }
    
    fileprivate func addPasswordTextField() {
        passwordTextField.delegate = self
        let width = topLogoView.frame.width
        self.topLogoView.addSubview(passwordTextField)
        passwordTextField.frame = CGRect(x: 30, y: logoView.frame.height + titleView.frame.height + emailTextField.frame.height + 10, width:  width - 60 , height: 30)
        self.topLogoView.addSubview(underline2)
        underline2.frame = CGRect(x: 30, y: passwordTextField.frame.origin.y + passwordTextField.frame.height, width: width - 60, height: 1)
    }

    fileprivate func addForgotPasswordButton() {
        forgotPasswordButton.frame = CGRect(x: 25, y: logoView.frame.height + titleView.frame.height + emailTextField.frame.height + passwordTextField.frame.height + 15, width: 150, height: 20)

        self.topLogoView.addSubview(forgotPasswordButton)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonDidClicked), for: .touchUpInside)
    }
    
    fileprivate func addLoginButton() {
        self.topLogoView.addSubview(loginButton)
        let width = topLogoView.frame.width
        loginButton.frame = CGRect(x: 30, y: logoView.frame.height + titleView.frame.height + emailTextField.frame.height + passwordTextField.frame.height + forgotPasswordButton.frame.height + 45, width:  width - 60, height: 40)

        loginButton.addTarget(self, action: #selector(loginButtonDidClicked), for: .touchUpInside)
    }


    @objc func loginButtonDidClicked(_ sender: UIButton) {
        print("logged In button did clicked")
        if (passwordTextField.text?.characters.count)! < 5 {
            self.displayAlertView("Password should have minimum 6 characters", message: "please enter passwod having greater than 6 characters.", handler: { (_) in self.passwordTextField.becomeFirstResponder() })
        } else {
        self.view.endEditing(true)
        loadingIndicator.center = view.center
        loadingIndicator.alpha = 0.9
        appDelegate.window?.addSubview(loadingIndicator)
        let requestDict = ["user_email": "\(String(describing: emailTextField.text!))",
            "password": "\(String(describing: passwordTextField.text!))"]
        loginWebService(requestParaDict: requestDict, requestMethod: POST, requestURL: LOGIN_URL) { [weak self] (result) in
            if let strongSelf = self {
                if result.errorCode == "0" {
                    if let userID = result.result?.user_id {
                        UserDefaults.standard.set(userID, forKey: "userID")
                    }
                    UserDefaults.standard.set(true, forKey: "isLoggedInSkipped")
                    let homeViewCtrl = FirstViewController()
                    DispatchQueue.main.async {
                        strongSelf.loadingIndicator.alpha = 0
                        strongSelf.navigationController?.pushViewController(homeViewCtrl, animated: true)
                    }
                    
                } else if result.errorCode == "2" {
                strongSelf.loginWebService(requestParaDict: requestDict, requestMethod: POST, requestURL: REGISTER_NEW_USER_URL, completion: { [weak self] (result) in
                    if result.errorCode == "1" {
                        let stringUserID: String?
                        stringUserID = String(describing: result.user_id!)
                        if let strongerSelf = self {
                            if let userID = stringUserID {
                                UserDefaults.standard.set(userID, forKey: "userID")
                            }
                            UserDefaults.standard.set(true, forKey: "isLoggedInSkipped")
                            let homeViewCtrl = ChooseFavViewController()
                            DispatchQueue.main.async {
                                strongerSelf.loadingIndicator.alpha = 0
                                strongerSelf.navigationController?.pushViewController(homeViewCtrl, animated: true)
                            }
                        }

                    } else {
                        DispatchQueue.main.async {
                            strongSelf.loadingIndicator.alpha = 0
                            strongSelf.displayAlertView("Login Failed", message: "Incorrect username or password.", handler: nil)
                        }
                    }
                })

                } else if result.errorCode == "1" {
                    DispatchQueue.main.async {
                        strongSelf.loadingIndicator.alpha = 0
                        strongSelf.displayAlertView("Login Failed", message: "Incorrect username or password.", handler: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.loadingIndicator.alpha = 0
                        strongSelf.displayAlertView("Login Failed", message: "Incorrect username or password.", handler: nil)
                    }
                    
                }
            }
        }
        }
    }
    
    @objc func forgotPasswordButtonDidClicked(_ sender: UIButton) {
        print("Forgot password button did clicked")
        let forgotPassViewCtrl = ForgotPasswordViewController()
        self.navigationController?.pushViewController(forgotPassViewCtrl, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func skipLogin() {
        print("Skip button did clicked")
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.skipButton.removeFromSuperview()
        }
        UserDefaults.standard.set(true, forKey: "isLoggedInSkipped")
        UserDefaults.standard.set("", forKey: "userID")
        let homeViewCtrl = ChooseFavViewController()
        self.navigationController?.pushViewController(homeViewCtrl, animated: true)
    }
    
    func loginWebService(requestParaDict: [String: Any]?, requestMethod: String,requestURL: String , completion: @escaping (Result) -> ()) {
        let url = URL(string: requestURL)
        var request = URLRequest(url: url!)
        request.httpMethod = requestMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let requestDict = requestParaDict {
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: requestDict, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                print(error)
            }
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            } else {
                do {
                    guard let data = data else {return}
                    let parsedData = try JSONDecoder().decode(Result.self, from: data)
                    completion(parsedData)
                } catch {
                    print(error.localizedDescription)
                }
            }
            }.resume()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        print("removed observers")
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (emailTextField.text?.isEmpty)! {
            //do nothing
        } else {
            guard let isValid = emailTextField.text?.isValidEmail() else { return }
            if !isValid {
                displayAlertView("This is not an Email", message: "please enter a valid email address", handler: { (_) in
                    self.emailTextField.becomeFirstResponder()
                    self.loginButton.isEnabled = false
                    self.loginButton.alpha = 1
                })
            } else {
                 self.loginButton.isEnabled = true
                 self.loginButton.alpha = 0.5
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == passwordTextField {
            guard let count = passwordTextField.text?.characters.count else { return true}
                switch count {
                case 5...:
                        self.loginButton.alpha = 1;
                        self.loginButton.isEnabled = true
                    return true
                default:
                        self.loginButton.alpha = 0.5;
                        self.loginButton.isEnabled = true
                    return true
                }
            } else {
                self.loginButton.alpha = 1
                self.loginButton.isEnabled = false
                return true
            }

    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        return false
    }
}

extension LoginViewController {
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

                let height = view.frame.origin.y + keyboard.height - 80 //(view.frame.height) - keyboard.height
                view.frame.origin.y = height
                keyboardIsShown = false
            } else {
                guard let keyboard = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {return}

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














