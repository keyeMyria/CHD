//
//  ContactUsViewController.swift
//  tabView
//
//  Created by CenSoft on 08/12/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit
import Eureka

class ContactUsViewController: FormViewController {
    
    enum CategoryList: String,CustomStringConvertible {
        case tablet_technical_support = "Tablet technical support"
        case website_technical_support = "Website technical support"
        case subscription_request = "Subscription request"
        case editorial_commetns = "Editorial commetns"
        case advertise_in_the_magezine = "Advertise in the magezine"
        case advertise_on_the_website = "Advertise on the website"
        
        var description: String {return rawValue}
        
        static let allValues = [tablet_technical_support, website_technical_support, subscription_request, editorial_commetns, advertise_in_the_magezine, advertise_on_the_website]
    }
    
    struct Dict {
        var firstName: String?
        var lastName: String?
        var category: String?
        var email: String?
        var daytimePhone: String?
        var city: String?
        var state: String?
        var country: String?
        var subject: String?
        var message: String?
    }
    var firstName: String?
    var isFirstNameValidate: Bool = false
    var lastName: String?
    var isLastNameValidate: Bool = false
    var category: String?
    var isCategoryValidate: Bool = false
    var email: String?
    var isEmailValidate: Bool = false
    var daytimePhone: String?
    var isPhoneValidate: Bool = false
    var city: String?
    var isCityValidate: Bool = false
    var state: String?
    var isStateValidate: Bool = false
    var country: String?
    var isCountryValidate: Bool = false
    var subject: String?
    var isSubjectValidate: Bool = false
    var message: String?
    var isMessageValidate: Bool = false
    var isAgreeTermsAndConditions: Bool = false
    
    var allValidationDone: Bool = false
    
    var pageTitle = String()
    var pageURL = String()
    
    var dictionary = [Dict]()
    
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
        
        self.title = "Contact Us"
        
        //Google Analyatics Code
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: pageTitle)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        let trimmingCharacters = CharacterSet(charactersIn: "1234567890 \n")
        
        UserDefaults.standard.set(true, forKey: "agree")
        UserDefaults.standard.synchronize()
        
        var rules = RuleSet<String>()
        rules.add(rule: RuleRequired())
        rules.add(rule: RuleEmail())
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .left
            
        }
        
        TextRow.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        
        form +++ Section("Category")
            <<< PushRow<CategoryList>() {
                $0.title = "Category"
                $0.selectorTitle = "Pick a category"
                $0.options = CategoryList.allValues
                $0.value = .tablet_technical_support    // initially selected
                $0.tag = "category"
                }.cellUpdate({ (_, row) in
                    let name = row.value
                    self.category = name.map { $0.rawValue }
                    self.isCategoryValidate = true
                }).onPresent({ (_, vc) in
                    vc.enableDeselection = false
                    vc.dismissOnSelection = false
                })
            +++ Section("Personal information")
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
                    
                   // cell.textField?.textAlignment = .left
                    
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
            .onRowValidationChanged { cell, row in
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
            <<< EmailRow() {
                $0.title = "Email"
                $0.placeholder = "user@emaple.com"
                $0.tag = "email"
                $0.add(ruleSet: rules)
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellSetup({ (cell, _) in
                    cell.textField.autocorrectionType = .no
                })
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
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
                $0.placeholder = "Contact Number"
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
            <<< TextRow(){
                $0.title = "City"
                $0.placeholder = "City"
                $0.tag = "city"
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
                        self.isCityValidate = false
                    } else {
                        guard var name = row.value else {return}
                        name = name.trimmingCharacters(in: trimmingCharacters)
                        if name.isEmpty {
                            cell.textField.text = ""
                            self.isCityValidate = false
                            return
                        }
                        self.city = name
                       self.isCityValidate = true
                        
                    }
            }
                .onRowValidationChanged { _, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        self.isCityValidate = false
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
                $0.title = "State"
                $0.placeholder = "State"
                $0.tag = "state"
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
                        self.isStateValidate = false
                    } else {
                        guard var name = row.value else {return}
                        name = name.trimmingCharacters(in: trimmingCharacters)
                        if name.isEmpty {
                            cell.textField.text = ""
                            self.isStateValidate = false
                            return
                        }
                        self.state = name
                       self.isStateValidate = true
                    
                    }
            }
                .onRowValidationChanged { _, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        self.isStateValidate = false
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
                $0.title = "Country"
                $0.placeholder = "Country"
                $0.tag = "country"
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
                        self.isCountryValidate = false
                    } else {
                        guard var name = row.value else {return}
                        name = name.trimmingCharacters(in: trimmingCharacters)
                        if name.isEmpty {
                            cell.textField.text = ""
                            self.isCountryValidate = false
                            return
                        }
                        self.country = name
                        self.isCountryValidate = true
                    }
                    
            }
                .onRowValidationChanged { _, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        self.isCountryValidate = false
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
                $0.title = "Subject"
                $0.placeholder = "Your Subject"
                $0.tag = "subject"
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
                        self.isSubjectValidate = false
                    } else {
                        guard var name = row.value else {return}
                        name = name.trimmingCharacters(in: trimmingCharacters)
                        if name.isEmpty {
                            cell.textField.text = ""
                            self.isSubjectValidate = false
                            return
                        }
                        self.subject = name
                        self.isSubjectValidate = true
                    
                    }
            }
                .onRowValidationChanged { _, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        self.isSubjectValidate = false
                        for (index, validateMessage) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validateMessage
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
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
                .onRowValidationChanged { _, row in
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
            +++ Section("Terms and conditions")
            <<< TextAreaRow() {
                $0.value = "By clicking Submit, you agree that you have read the Terms of Service of our website. Please be aware that we occasionally receive emails from visitors asking about order status and refunds. We are a magazine website and not an e-commerce website. We do not sell products nor do we facilitate any transactions. All we can suggest is to please check your credit card statement to determine who it is that you should be contacting in order to resolve your issue. You should see the company name and contact phone number listed on your credit card statement. Hopefully this will be very effective at resolving the issue. Please note that we read all editorial comments and questions, but we cannot answer each one individually."
                }.cellUpdate({ (cell, _) in
                    cell.textView.isEditable = false
                    cell.textView.font = UIFont.systemFont(ofSize: 13)
                })
            
           form +++ SelectableSection<ListCheckRow<String>>("", selectionType: .singleSelection(enableDeselection: true))
        
            let continents = ["Agree Terms and Conditions"]
            for option in continents {
                form.last! <<< ListCheckRow<String>(option){ listRow in
                    listRow.title = option
                    listRow.selectableValue = option
                    listRow.value = nil
                    listRow.tag = "terms"
                    
                    }
                    .onChange({ (_) in
                        if UserDefaults.standard.bool(forKey: "agree") {
                            UserDefaults.standard.set(false, forKey: "agree")
                            self.isAgreeTermsAndConditions = true
                            print("true")
                        } else {
                            UserDefaults.standard.set(true, forKey: "agree")
                            self.isAgreeTermsAndConditions = false
                            print("false")
                        }
                    })
            }
        
            form +++ Section()
            <<< ButtonRow(){
                $0.title = "Send Message"
                $0.tag = "submit"
                }.onCellSelection({ (_, _) in
                    print("Clicked")
                    if self.isCategoryValidate && self.isFirstNameValidate && self.isLastNameValidate && self.isEmailValidate && self.isPhoneValidate && self.isCityValidate && self.isStateValidate && self.isCountryValidate && self.isSubjectValidate && self.isMessageValidate{
                        if self.isAgreeTermsAndConditions {
                            if self.category == nil {
                                self.category = "Tablet technical support"
                            }
                        self.dictionary.append(Dict(firstName: self.firstName, lastName: self.lastName, category: self.category, email: self.email, daytimePhone: self.daytimePhone, city: self.city, state: self.state, country: self.country, subject: self.subject, message: self.message))
                        self.submitButtonDidClicked(dict: self.dictionary)
                        } else {
                            let alert = UIAlertController(title: "Warning", message: "You must agree terms and conditions", preferredStyle: .alert)
                            let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        let alert = UIAlertController(title: "Warning", message: "All fields are compulsory and should be validate", preferredStyle: .alert)
                        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
        
        loadingIndicator.center = view.center
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(loadingIndicator)
        
    }
    
    func submitButtonDidClicked(dict: [Dict]) {
        print("sending message...")
        loadingIndicator.alpha = 0.9
        print(dict[0].firstName!, dict[0].lastName!, dict[0].category!, dict[0].daytimePhone!, dict[0].email!, dict[0].city!, dict[0].state!, dict[0].country!, dict[0].subject!, dict[0].message!)
        
        let requestDictionary = ["category": dict[0].category!, "first-name":dict[0].firstName!, "last-name":dict[0].lastName!, "your-email":dict[0].email!, "DaytimePhone":dict[0].daytimePhone!, "city":dict[0].city!, "state":dict[0].state!, "Country":dict[0].country!, "subject":dict[0].subject!, "your-message":dict[0].message!]
        
        APIManager.sharedInstance.sendMessageToAdmin(requestDict: requestDictionary, requestURL: pageURL) { (result) in
            var alertTitle = String()
            let message = result?.message
            let errorCode = result?.error
            if errorCode == 0 {
                alertTitle = "Success"
                self.allValidationDone = true
                DispatchQueue.main.async {
                    self.loadingIndicator.alpha = 0
                    self.resetAllFields()
                }
                
            } else {
                alertTitle = "Error"
                self.dictionary.removeAll()
                self.allValidationDone = false
                DispatchQueue.main.async {
                    self.loadingIndicator.alpha = 0
                }
            }
            let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                if self.allValidationDone {
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
//        isReseting = true
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
//        let city: TextRow = self.form.rowBy(tag: "city")!
//        city.value = ""
//        isCityValidate = false
//        let state: TextRow = self.form.rowBy(tag: "state")!
//        state.value = ""
//        isStateValidate = false
//        let country: TextRow = self.form.rowBy(tag: "country")!
//        country.value = ""
//        isCountryValidate = false
//        let subject: TextRow = self.form.rowBy(tag: "subject")!
//        subject.value = ""
//        isSubjectValidate = false
//        let message: TextAreaRow = self.form.rowBy(tag: "message")!
//        message.value = ""
//        isMessageValidate = false
//        let agreeTerms: ListCheckRow<String> = self.form.rowBy(tag: "terms")!
//        agreeTerms.value = nil
        isAgreeTermsAndConditions = false
        UserDefaults.standard.set(true, forKey: "agree")
        UserDefaults.standard.synchronize()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
