//
//  supportPage.swift
//  VeganApp
//
//  Created by Luis Gonzalez on 11/17/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class supportPage : UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    let colorPINK: String = "#E1204D";
    let colorGREEN: String = "#8CB618";
    let colorBLUE: String = "#20AEE1";
    let colorButtonBlue = "#204DE1";
    let colorWHITE: String = "#ffffff";
    let colorLIGHT_GRAY: String = "#c2c2c2";
    let colorComplimetary = "#E15320";
    let GRAY: String = "#e3e2e1";
    let emailDirectory:[String] = ["vegansuggestions@gmail.com"];
    var mail = MFMailComposeViewController();
    
    lazy var supportLabel : UILabel = {
        let label = UILabel();
        label.text = "Support";
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 35.0);
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 60);
        return label;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        toolbarConstraints();
        aboutToolBar();
        view.addSubview(supportLabel);
        constraints_support();
        view.addSubview(nameInput);
        view.addSubview(emailInput);
        constraints_inputs();
        view.addSubview(userMessageBox);
        constraints_message();
        view.addSubview(sendEmailButton);
        constraints_button();
        mail.mailComposeDelegate = self;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.nameInput.delegate = self;
        self.emailInput.delegate = self;
        self.userMessageBox.delegate = self;
    }
    
    private func aboutToolBar()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "about"), style: .plain, target: self, action: #selector(showCredits));
    }
    @objc private func showCredits()
    {
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "aboutVC") as? aboutController;
        self.navigationController?.pushViewController(viewController!, animated: true);
        print("Launched About");
        return;
    }
    
    public func constraints_button()
    {
        let screenWidth = (self.view.frame.size.width) - 10;
        sendEmailButton.backgroundColor = hexStringToUIColor(hex: colorBLUE);
        sendEmailButton.anchorView(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: screenWidth, height: 40));
        
    }
    
    var sendEmailButton: UIButton = {
        let button = UIButton();
        button.setTitle("Send Email", for: .normal);
        button.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside);
        return button;
    }()
    
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    @objc public func onButtonClick(sender : UIButton!)
    {
       // check if Values are null here
        let message = userMessageBox.text!;
        let email = emailInput.text!;
        let userMessage = userMessageBox.text!;
        
        if(!isValidEmail(emailStr: email) || userMessage.isEmpty || email.isEmpty )
        {
            logEmptyFieldsError();
            return;
        }
        else
        {
            if(!MFMailComposeViewController.canSendMail())
            {
                logErrorToUser();
            }
            else
            {
                sendEmail(userMessage: message, cc: email);
            }
        }
    
    }
    
    func sendEmail(userMessage: String, cc: String)
    {
        mail.setToRecipients(emailDirectory);
        mail.setSubject("Support");
        mail.setMessageBody(userMessage, isHTML: false)
        self.present(mail, animated: true);
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if(result == .sent){
            controller.dismiss(animated: true, completion: nil);
            showSuccess();
            return;
        }
        else if(result == .failed)
        {
            controller.dismiss(animated: true, completion: nil);
            logErrorToUser();
            return;
        }
        else if(result == .cancelled)
        {
            controller.dismiss(animated: true, completion: nil);
            logErrorToUser();
            return;
        }
    }
    
    private func showSuccess()
    {
      let error = UIAlertController(title: "Email Sent!", message: "Thanks for the feedback!", preferredStyle: .alert);
        let action = UIAlertAction(title: "Close", style: .cancel, handler: { (_) in self.navigationController?.popViewController(animated: true)});
        error.addAction(action);
        self.present(error, animated: true, completion: nil);
    }
    
    private func logErrorToUser()
    {
        print("Cannot send Log Error to User");
        let error = UIAlertController(title: "Cannot Send Email ", message: "Try again later..", preferredStyle: .alert);
        let action = UIAlertAction(title: "Close", style: .cancel, handler: { (_) in self.navigationController?.popViewController(animated: true)});
        error.addAction(action);
        self.present(error, animated: true, completion: nil);
    }
    
    private func logEmptyFieldsError()
    {
        let error = UIAlertController(title: "Missing Fields!", message: "Please fill out all text fields..", preferredStyle: .alert);
        let action = UIAlertAction(title: "Retry", style: .cancel, handler: nil);
        error.addAction(action);
        self.present(error, animated: true, completion: nil);
    }
    
    public func constraints_message()
    {
        let screenWidth = (self.view.frame.size.width) - 10;
        userMessageBox.anchorView(top: emailInput.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 5), size: .init(width: screenWidth, height: 45));
        userMessageBox.addLine(position: .LINE_POSITION_BOTTOM, color: hexStringToUIColor(hex: colorComplimetary), width: 0.5);
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        nameInput.resignFirstResponder();
        nameInput.returnKeyType = .done;
        emailInput.resignFirstResponder();
        emailInput.returnKeyType = .done
        userMessageBox.resignFirstResponder();
        userMessageBox.returnKeyType = .done;
        return true
    }

    // Constraints for TextFields @ Name and Email
    // Sets color as well
    public func constraints_inputs()
    {
        let screenWidth = (self.view.frame.size.width / 1.5);
        nameInput.anchorView(top: supportLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 5, bottom: 0, right: 0), size: .init(width: screenWidth , height: 40));
        emailInput.anchorView(top: nameInput.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: 5, bottom: 0, right: 0), size: .init(width: screenWidth, height: 40));
        nameInput.backgroundColor = hexStringToUIColor(hex: colorLIGHT_GRAY);
        emailInput.backgroundColor = hexStringToUIColor(hex: colorLIGHT_GRAY);
    }
    
    var userMessageBox : UITextField = {
        let textView = UITextField();
        textView.returnKeyType = UIReturnKeyType.done;
        textView.text = "Message here";
        textView.font = UIFont(name: "Helvetica-Light", size: 14);
        textView.keyboardType = UIKeyboardType.default;
        textView.returnKeyType = UIReturnKeyType.done;
        textView.clearButtonMode = UITextField.ViewMode.whileEditing;
        textView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center;
        textView.textColor = UIColor.black;
        textView.clearsOnInsertion = true;
        textView.translatesAutoresizingMaskIntoConstraints = false;
        return textView;
    }()
    
    var nameInput : UITextField = {
        let name = UITextField();
        name.text = "Name";
        name.keyboardType = UIKeyboardType.default;
        name.returnKeyType = UIReturnKeyType.done;
        name.font = UIFont(name: "Helvetica-Light", size: 14);
        name.clearButtonMode = UITextField.ViewMode.whileEditing;
        name.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        name.textColor = UIColor.black;
        name.clearsOnInsertion = true;
        name.borderStyle = .roundedRect;
        return name;
        
    }()
    var emailInput : UITextField = {
        let email = UITextField();
        email.text = "Email";
        email.keyboardType = UIKeyboardType.emailAddress;
        email.returnKeyType = UIReturnKeyType.done;
         email.font = UIFont(name: "Helvetica-Light", size: 14)
        email.clearButtonMode = UITextField.ViewMode.whileEditing;
        email.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center;
        email.clearsOnInsertion = true;
        email.textColor = UIColor.black;
        email.borderStyle = .roundedRect;
        return email;
        
    }()
    
    public func constraints_support()
    {
        supportLabel.textColor = hexStringToUIColor(hex: colorBLUE);
        supportLabel.anchorView(top:view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor,padding: .init(top: 0, left: 10, bottom: 0, right: 0) ,size: .init(width: 300, height: 60));
    }
    
    private func toolbarConstraints()
    {
        self.navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: colorWHITE);
        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: colorBLUE);
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.hidesBarsOnSwipe = false;
    }
    
    
    public func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}
extension UIView{
    
    func anchorView(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

extension UIView {
    func addLine(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}


