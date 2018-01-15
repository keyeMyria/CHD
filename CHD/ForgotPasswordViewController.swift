//
//  ForgotPasswordViewController.swift
//  CHD
//
//  Created by CenSoft on 15/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Type e-mail to get password"
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
    
    private lazy var sendEmailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send email", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.layer.cornerRadius = 6
        return button
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
        self.view.backgroundColor = .white
        self.title = "Forgot Password"
        
        if #available(iOS 11.0, *){
            self.emailTextField.frame = CGRect(x: 10, y: (self.navigationController?.navigationBar.frame.height)! + 10, width: view.frame.width - 20, height: 30)
        } else {
            self.emailTextField.frame = CGRect(x: 10, y: (self.navigationController?.navigationBar.frame.height)! + 30, width: view.frame.width - 20, height: 30)
        }
        self.view.addSubview(emailTextField)
        
        sendEmailButton.frame = CGRect(x: 10, y: emailTextField.frame.origin.y + emailTextField.frame.height + 20, width: view.frame.width - 20, height: 30)
        sendEmailButton.addTarget(self, action: #selector(sendEmailToUser), for: .touchUpInside)
        self.view.addSubview(sendEmailButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    

    @objc func sendEmailToUser() {
        guard let isValid = emailTextField.text?.isValidEmail() else { return }
        if isValid {
            loadingIndicator.center = view.center
            loadingIndicator.alpha = 0.9
            appDelegate.window?.addSubview(loadingIndicator)
            let requestParaDict = ["user_email": "\(emailTextField.text!)"]
            LoginViewController.sharedInstance.loginWebService(requestParaDict: requestParaDict, requestMethod: POST, requestURL: FORGOT_PASSWORD_URL) { (result) in
                if result.errorCode == "1" {
                    DispatchQueue.main.async {
                        self.loadingIndicator.alpha = 0
                        self.displayAlertView("Email sent Succefully", message: "Please check your mail inbox to find the new password", handler: nil)
                        let alert = UIAlertController(title: "Email sent Succefully", message: "Please check your mail inbox to find the new password", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.loadingIndicator.alpha = 0
                        self.displayAlertView("E-mail is not registered", message: "Please enter registered email address or register again", handler: nil)
                    }
                }
            }
        } else {
            displayAlertView("This is not an Email", message: "please enter a valid email address", handler: { (_) in
                self.emailTextField.becomeFirstResponder()
            })
        }
        
    }
    


}
