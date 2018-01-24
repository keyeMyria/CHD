//
//  AdvertWithUsViewController.swift
//  tabView
//
//  Created by CenSoft on 11/12/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit
import Eureka


class AdvertWithUsViewController: FormViewController {
    
    struct Dict {
        var firstName: String?
        var lastName: String?
        var email: String?
        var daytimePhone: String?
        var companyName: String?
        var website: String?
        var yesNo: String?
        var emailPhone: String?
        var message: String?
    }
    var firstName: String?
    var isFirstNameValidate: Bool = false
    var lastName: String?
    var isLastNameValidate: Bool = false
    var email: String?
    var isEmailValidate: Bool = false
    var daytimePhone: String?
    var isPhoneValidate: Bool = false
    var companyName: String?
    var isCompanyValidate: Bool = false
    var website: String?
    var isWebsiteValidate: Bool = false
    var yesNo: String?
    var emailPhone: String?
    var message: String?
    var isMessageValidate: Bool = false
    
    var allValidatationDone: Bool = false
    
    var pageTitle = String()
    var pageURL = String()
    
    var dictionary = [Dict]()

    var yesNoChanged = false
    var emailPhoneChanged = false
    
    lazy var loadingIndicator: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 210, height: 100)
        view.layer.cornerRadius = 6
        view.addSubview(activityIndicator)
        activityIndicator.color = .white
        activityIndicator.frame = CGRect(x: 10, y: view.frame.height / 2 - 15, width: 30, height: 30)
        activityIndicator.startAnimating()
        let label = UILabel()
        label.text = "Sending message..."
        label.textColor = .white
        label.frame = CGRect(x: 50, y: view.frame.height / 2 - 15, width: 150, height: 30)
        view.addSubview(label)
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: pageTitle)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right
            
        }
        
        TextRow.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        
        let trimmingCharacters = CharacterSet(charactersIn: "1234567890 \n")
        
        self.title = "Advertise with Us"
        form +++ Section("Personal information")
            <<< TextRow(){
                $0.title = "First Name"
                $0.placeholder = "First Name"
                $0.tag = "first"
                $0.add(rule: RuleMaxLength(maxLength: 20))
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellSetup({ (cell, _) in
                    cell.textField.autocorrectionType = .no
                })
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        self.isFirstNameValidate = false
                    } else {
                        guard var name = row.value else {return}
                        name = name.trimmingCharacters(in: trimmingCharacters)
                        name = name.replacingOccurrences(of: " ", with: "")
                        if name.isEmpty {
                            cell.textField.text = ""
                            self.isFirstNameValidate = false
                            return
                        } else {
                            cell.textField.text = name
                        }
                        self.firstName = name
                        self.isFirstNameValidate = true
                    }
            }
            .onRowValidationChanged { _, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        self.isFirstNameValidate = false
                        for (index, validateMessage) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validateMessage
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< TextRow(){
                $0.title = "Last Name"
                $0.placeholder = "Last Name"
                $0.tag = "lastName"
                $0.add(rule: RuleMaxLength(maxLength: 20))
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellSetup({ (cell, _) in
                    cell.textField.autocorrectionType = .no
                })
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        self.isLastNameValidate = false
                    } else {
                        guard var name = row.value else {return}
                        name = name.trimmingCharacters(in: trimmingCharacters)
                        name = name.replacingOccurrences(of: " ", with: "")
                        if name.isEmpty {
                            cell.textField.text = ""
                            self.isLastNameValidate = false
                            return
                        } else {
                            cell.textField.text = name
                        }
                        self.lastName = name
                        self.isLastNameValidate = true
                    }
            }
                .onRowValidationChanged { _, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        self.isLastNameValidate = false
                        for (index, validateMessage) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validateMessage
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< TextRow(){
                $0.title = "Company Name"
                $0.placeholder = "Company"
                $0.tag = "company"
                $0.add(rule: RuleMaxLength(maxLength: 30))
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellSetup({ (cell, _) in
                    cell.textField.autocorrectionType = .no
                })
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        self.isCompanyValidate = false
                    } else {
                        guard var name = row.value else {return}
                        name = name.trimmingCharacters(in: trimmingCharacters)
                        if name.isEmpty {
                            cell.textField.text = ""
                            self.isCompanyValidate = false
                            return
                        }
                        self.companyName = name
                        self.isCompanyValidate = true
                    }
            }
                .onRowValidationChanged { _, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        self.isCompanyValidate = false
                        for (index, validateMessage) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validateMessage
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< URLRow(){
                $0.title = "Website URL"
                $0.placeholder = "https://example.com"
                $0.tag = "website"
                $0.add(rule: RuleURL())
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellSetup({ (cell, _) in
                    cell.textField.autocorrectionType = .no
                    cell.textField.keyboardType = .URL
                })
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        self.isWebsiteValidate = false
                    } else {
                        guard let name = row.value else {return}
                        let str = String(describing: name)
                        if str.isEmpty {
                            self.isWebsiteValidate = false
                            return
                        }
                        self.website = str
                        self.isWebsiteValidate = true
                    }
            }
                .onRowValidationChanged { _, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        self.isWebsiteValidate = false
                        for (index, validateMessage) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validateMessage
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< EmailRow() {
                $0.title = "Email"
                $0.placeholder = "user@example.com"
                $0.tag = "email"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellSetup({ (cell, _) in
                    cell.textField.autocorrectionType = .no
                })
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        self.isEmailValidate = false
                    } else {
                        guard let name = row.value else {return}
                        if name.isEmpty {
                            self.isEmailValidate = false
                            return
                        }
                        self.email = name
                        self.isEmailValidate = true
                    }
            }
                .onRowValidationChanged { _, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        self.isEmailValidate = false
                        for (index, validateMessage) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validateMessage
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< PhoneRow(){
                $0.title = "Contact"
                $0.placeholder = "Phone Number"
                $0.tag = "phone"
                $0.add(rule: RuleMinLength(minLength: 10))
                $0.add(rule: RuleMaxLength(maxLength: 13))
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellSetup({ (cell, _) in
                    cell.textField.autocorrectionType = .no
                })
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        self.isPhoneValidate = false
                    } else {
                        guard let name = row.value else {return}
                        if name.isEmpty {
                            self.isPhoneValidate = false
                            return
                        }
                        self.daytimePhone = name
                        self.isPhoneValidate = true
                    }
            }
                .onRowValidationChanged { _, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        self.isPhoneValidate = false
                        for (index, validateMessage) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validateMessage
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            +++ Section("Does your brand currently buy online display advertising?")
            <<< SegmentedRow<String>(){
                $0.title = ""
                $0.options = ["Yes", "No"]
                $0.value = $0.options?.first
                $0.tag = "yesNo"
                }.onChange({ (row) in
                        guard let name = row.value else {return}
                        self.yesNo = name
                        print(name)
                })
                .cellUpdate({ (_, row) in
                    guard let name = row.value else {return}
                    self.yesNo = name
                    print(name)
                })
            
            +++ Section("How do you prefer to be contacted?")
            <<< SegmentedRow<String>(){
                $0.title = ""
                $0.options = ["E-mail", "Phone"]
                $0.value = $0.options?.first
                $0.tag = "emailPhone"
                }.onChange({ (row) in
                        guard let name = row.value else {return}
                        self.emailPhone = name
                })
                .cellUpdate({ (cell, row) in
                    guard let name = row.value else {return}
                    self.emailPhone = name
                })
          
            +++ Section("Your Comment")
            <<< TextAreaRow(){
                $0.placeholder = "Type comment here"
                $0.tag = "message"
                $0.add(rule: RuleMaxLength(maxLength: 150))
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textView.textColor = .red
                        self.isMessageValidate = false
                    } else {
                        guard let name = row.value else {return}
                        if name.isEmpty {
                            self.isMessageValidate = false
                            return
                        }
                        self.message = name
                        self.isMessageValidate = true
                    }
            }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        self.isMessageValidate = false
                        for (index, validateMessage) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validateMessage
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            +++ Section()
            <<< ButtonRow(){
                $0.title = "Send Message"
                $0.tag = "submit"
                }.onCellSelection({ (cell, row) in
                    print("Clicked")
                    if self.isFirstNameValidate && self.isLastNameValidate && self.isEmailValidate && self.isPhoneValidate && self.isCompanyValidate && self.isWebsiteValidate && self.isMessageValidate{
                        self.dictionary.append(Dict(firstName: self.firstName, lastName: self.lastName, email: self.email, daytimePhone: self.daytimePhone, companyName: self.companyName, website: self.website, yesNo: self.yesNo, emailPhone: self.emailPhone, message: self.message))
                        self.submitButtonDidClicked(dict: self.dictionary)
                    } else {
                        let alert = UIAlertController(title: "Warning", message: "All fields are compulsory and should be validate", preferredStyle: .alert)
                        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
        
        loadingIndicator.center = view.center
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(loadingIndicator)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitButtonDidClicked(dict: [Dict]) {
        print("sending message...")
        loadingIndicator.alpha = 0.9
        yesNoChanged = true
        emailPhoneChanged = true
        print(dict[0].firstName!, dict[0].lastName!, dict[0].daytimePhone!, dict[0].email!, dict[0].companyName!, dict[0].website!,dict[0].yesNo!, dict[0].emailPhone!, dict[0].message!)
        
        let requestDictionary = ["firstname":dict[0].firstName!, "lastname":dict[0].lastName!,"companyname":dict[0].companyName,"websiteurl":dict[0].website, "email":dict[0].email!, "phone":dict[0].daytimePhone!, "message":dict[0].message!, "buyonline":yesNo, "contactinfo":emailPhone]
        
        APIManager.sharedInstance.sendMessageToAdmin(requestDict: requestDictionary as! [String : String], requestURL: pageURL) { (result) in
            var alertTitle = String()
            let message = result?.message
            let errorCode = result?.error
            if errorCode == 0 {
                alertTitle = "Success"
                self.allValidatationDone = true
                DispatchQueue.main.async {
                    self.resetAllFields()
                    self.loadingIndicator.alpha = 0
                }
            } else {
                alertTitle = "Error"
                self.dictionary.removeAll()
                self.allValidatationDone = false
                DispatchQueue.main.async {
                    self.loadingIndicator.alpha = 0
                }
            }
            let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                if self.allValidatationDone {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    func resetAllFields() {
        dictionary.removeAll()
//        let firstName: TextRow = self.form.rowBy(tag: "first")!
//        firstName.value = ""
//        isFirstNameValidate = false
//        let lastName: TextRow = self.form.rowBy(tag: "lastName")!
//        lastName.value = ""
//        isLastNameValidate = false
//        let email: EmailRow = self.form.rowBy(tag: "email")!
//        email.value = ""
//        isEmailValidate = false
//        let phone: PhoneRow = self.form.rowBy(tag: "phone")!
//        phone.value = ""
//        isPhoneValidate = false
//        let company: TextRow = self.form.rowBy(tag: "company")!
//        company.value = ""
//        isCompanyValidate = false
//        let website: URLRow = self.form.rowBy(tag: "website")!
//        let str = URL(string: "")
//        website.value = str
//        isWebsiteValidate = false
//        let yesNO: SegmentedRow<String> = self.form.rowBy(tag: "yesNo")!
//        let yesNoOptions = yesNO.options?.first
//        yesNO.value = yesNoOptions
//        let emailPhone: SegmentedRow<String> = self.form.rowBy(tag: "emailPhone")!
//        let emailPhoneOptions = emailPhone.options?.first
//        emailPhone.value = emailPhoneOptions
//        let message: TextAreaRow = self.form.rowBy(tag: "message")!
//        message.value = ""
//        isMessageValidate = false
    }
    

}
