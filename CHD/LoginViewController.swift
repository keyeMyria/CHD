//
//  LoginViewController.swift
//  CHD
//
//  Created by CenSoft on 11/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
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

class LoginViewController: UIViewController {
    
    private lazy var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.8)
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
        imageView.image = #imageLiteral(resourceName: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.text = "ConsumerHealthDigest"
        label.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        let string_to_color = "Health"
        let blueColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        let range = (label.text as! NSString).range(of: string_to_color)
        
        let attribute = NSMutableAttributedString.init(string: label.text!)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: blueColor , range: range)
        label.attributedText = attribute
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    
    private lazy var subTitle: UILabel = {
        let label = UILabel()
        label.text = "Your trusted Source for Good health"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "E-mail"
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 6
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        textField.layer.borderWidth = 0.4
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Login Password or Create a Password"
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 6
        textField.autocorrectionType = .no
        textField.layer.borderWidth = 0.4
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.layer.cornerRadius = 6
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot your password?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleLabel?.textAlignment = .left
        return button
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var dividerLine1: UILabel = {
        let firstView = UILabel()
        firstView.backgroundColor = .gray
        firstView.frame.size.height = 2
        return firstView
    }()
    
    private lazy var dividerLine2: UILabel = {
        let firstView = UILabel()
        firstView.backgroundColor = .gray
        firstView.frame.size.height = 2
        return firstView
    }()
    
    private lazy var ORLabel: UILabel = {
        let secondView = UILabel()
        secondView.text = "OR"
        secondView.textColor = .gray
        return secondView
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "login")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundImage()
        setupTopView()
        addEmailTextField()
        addPasswordTextField()
        addLoginButton()
        addForgotPasswordButton()
        addConstraintsToSkipButton()
        //addDivider()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    fileprivate func setupTopView() {
        self.blurView.addSubview(containerView)
        containerView.frame = CGRect(x: 0, y: (view.frame.height / 2) - 250, width: view.frame.width, height: 500)
        
        self.containerView.addSubview(topLogoView)
        topLogoView.frame = CGRect(x: (containerView.frame.width / 2) - 150, y: 10, width: 300, height: 150)

        topLogoView.addSubview(logoView)
        logoView.frame = CGRect(x: (topLogoView.frame.width / 2) - 15, y: 10, width: 30, height: 30)
        
        topLogoView.addSubview(mainTitle)
        mainTitle.frame = CGRect(x: (topLogoView.frame.width / 2) - 150, y: logoView.frame.height + 20, width: 300, height: 30)
        
        topLogoView.addSubview(subTitle)
        subTitle.frame = CGRect(x: (topLogoView.frame.width / 2) - 150, y: logoView.frame.height + mainTitle.frame.height + 20, width: 300, height: 20)
    }
    
    func addConstraintsToSkipButton() {
        self.view.addSubview(skipButton)
        skipButton.addTarget(self, action: #selector(skipLogin), for: .touchUpInside)
        if #available(iOS 11.0, *) {
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        } else {
            // Fallback on earlier versions
            skipButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        }
    }
    
    fileprivate func addBackgroundImage() {
        self.view.addSubview(backgroundImage)
        self.view.addSubview(blurView)
        blurView.frame = self.view.frame
        backgroundImage.frame = self.view.frame
    }
    
    fileprivate func addEmailTextField() {
        emailTextField.delegate = self
        self.containerView.addSubview(emailTextField)
        emailTextField.frame = CGRect(x: 10, y: topLogoView.frame.height + 20, width: view.frame.width - 20, height: 30)
    }
    
    fileprivate func addPasswordTextField() {
        passwordTextField.delegate = self
        self.containerView.addSubview(passwordTextField)
        passwordTextField.frame = CGRect(x: 10, y: topLogoView.frame.height + emailTextField.frame.height + 30, width: view.frame.width - 20, height: 30)
    }
    
    fileprivate func addLoginButton() {
        self.containerView.addSubview(loginButton)
        loginButton.frame = CGRect(x: 10, y: topLogoView.frame.height + emailTextField.frame.height + passwordTextField.frame.height + 40, width: view.frame.width - 20, height: 30)
        loginButton.addTarget(self, action: #selector(loginButtonDidClicked), for: .touchUpInside)
    }
    
    fileprivate func addForgotPasswordButton() {
        forgotPasswordButton.frame = CGRect(x: 10, y: topLogoView.frame.height + emailTextField.frame.height + passwordTextField.frame.height + loginButton.frame.height + 50, width: 150, height: 20)
        self.containerView.addSubview(forgotPasswordButton)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonDidClicked), for: .touchUpInside)
    }
    
    fileprivate func addDivider() {
        self.view.addSubview(dividerView)
        
        dividerView.frame = CGRect(x: 10, y: topLogoView.frame.origin.y + emailTextField.frame.height + passwordTextField.frame.height + loginButton.frame.height + forgotPasswordButton.frame.height + 60, width: 150, height: 20)
        dividerView.addSubview(dividerLine1)
        dividerLine1.frame = CGRect(x: 10, y: 5, width: 150, height: 2)
        dividerView.addSubview(ORLabel)
        ORLabel.frame = CGRect(x: 170, y: 5, width: 50, height: 20)
        dividerView.addSubview(dividerLine2)
        dividerLine2.frame = CGRect(x: 230, y: 5, width: 150, height: 2)
    }
    
    @objc func loginButtonDidClicked(_ sender: UIButton) {
        print("logged In button did clicked")
    }
    
    @objc func forgotPasswordButtonDidClicked(_ sender: UIButton) {
        print("Forgot password button did clicked")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func skipLogin() {
        print("Skip button did clicked")
        DispatchQueue.main.async {
            self.skipButton.removeFromSuperview()
        }
        let homeViewCtrl = FirstViewController()
        self.navigationController?.pushViewController(homeViewCtrl, animated: true)
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
        if let _ = emailTextField.text?.isEmpty {
            //do nothing
        } else {
            guard let isValid = emailTextField.text?.isValidEmail() else { return }
            if !isValid {
                let alert = UIAlertController(title: "email no valid", message: "please enter a valid email address", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.emailTextField.becomeFirstResponder()
                }
                alert.addAction(action)
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
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














