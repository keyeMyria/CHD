//
//  AlertViewController.swift
//  CHD
//
//  Created by CenSoft on 15/01/18.
//  Copyright © 2018 CenSoft. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func displayAlertView(_ title: String, message: String, handler: ((UIAlertAction) -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
        }
        alert.addAction(action)
        DispatchQueue.main.async {
            if let completion = handler {
                completion(action)
            }
            self.present(alert, animated: true, completion: nil)
            
        }
    }

    func displayAlertViewTextField(_ title: String, message: String, textField: UITextField, handler: ((UIAlertAction) -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            textField.becomeFirstResponder()
        }
        alert.addAction(action)
            if let completion = handler {
                completion(action)
            }
            self.present(alert, animated: true, completion: nil)

        }

}
