//
//  contactViewController.swift
//  VeganApp
//
//  Created by Luis Gonzalez on 8/21/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import UIKit
import MessageUI


/*
 Change color of continer background
 cannot see certain colors that should be seen
 */

class contactViewController : UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate
{
    lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView();
        scroll.backgroundColor = UIColor.white;
        scroll.isScrollEnabled = true;
        scroll.translatesAutoresizingMaskIntoConstraints = false;
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 650);
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height);
        return scroll;
    }()
    
    var userInfoStack = UIStackView();
    let colorPINK: String = "#E1204D";
    let colorGREEN: String = "#8CB618";
    let colorBLUE: String = "#20AEE1";
    let colorWHITE: String = "#ffffff";
    let colorLIGHT_GRAY: String = "#919191";
    let GRAY: String = "#e3e2e1";
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        self.hideKeyboardWhenTappedAround();
        viewConstraints();
        toolbarConstraints();
        self.view.addSubview(scrollView);
        scrollViewConstraints();
        scrollView.addSubview(containerView);
        constraints();
        containerView.addSubview(userInfoStackView);
        [stackNameInput, stackEmailInput, stackSubjectInput].forEach{userInfoStackView.addArrangedSubview($0)}
        stackViewAndViews_C();
        containerView.addSubview(userMessageBox);
        userMessageConstraints();
        
        self.view.addSubview(supportLabel);
        supportLableConstraints();
        
        containerView.addSubview(imageViewEmail);
        imageViewEmailConstraints();
        containerView.addSubview(sendEmailButton);
        buttonConstraints();
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = +50;
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0;
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
    func viewConstraints()
    {
        self.navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: "E1204D");
        self.navigationController?.navigationBar.barTintColor = UIColor.white;
    }
    
    func scrollViewConstraints()
    {
        scrollView.backgroundColor = hexStringToUIColor(hex: colorWHITE);
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true;
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true;
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true;
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true;
    }
    
    
    var sendEmailButton: UIButton = {
        let button = UIButton();
        button.setTitle("Send Email", for: .normal);
        button.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside);
        return button;
    }()
    
    public func buttonConstraints()
    {
        sendEmailButton.anchor(top: containerView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 5, bottom: 0, right: 5), size: .init(width: UIScreen.main.bounds.width, height: 40));
        sendEmailButton.backgroundColor = hexStringToUIColor(hex: colorBLUE);
        sendEmailButton.layer.cornerRadius = 5;
    }
    
    // left of here
    // cannot check since i dont have my Cable
    @objc public func onButtonClick(sender : UIButton!)
    {
       // check if Values are null here
        
        if( stackNameInput.text!.isEmpty && stackEmailInput.text!.isEmpty && stackSubjectInput.text!.isEmpty )
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
                sendEmail();
            }
        }
    
    }
    
    public func logEmptyFieldsError()
    {
        let error = UIAlertController(title: "Missing Fields!", message: "Please fill out all text fields..", preferredStyle: .alert);
        let action = UIAlertAction(title: "Retry", style: .cancel, handler: nil);
        error.addAction(action);
        self.present(error, animated: true, completion: nil);
    }
    
    public func sendEmail()
    {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["vegansuggestions@gmail.com"])
        mail.setSubject("My Subject")
        mail.setMessageBody("Message is here", isHTML: false)
        self.present(mail, animated: true)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func logErrorToUser()
    {
        let error = UIAlertController(title: "Cannot Send Email ", message: "Try again later..", preferredStyle: .alert);
        let action = UIAlertAction(title: "Close", style: .cancel, handler: { (_) in self.navigationController?.popViewController(animated: true)});
        error.addAction(action);
        self.present(error, animated: true, completion: nil);
    }
    
    var imageViewEmail : UIImageView = {
       
        let imageView = UIImageView();
        imageView.image = UIImage(named: "eImage");
        imageView.backgroundColor = UIColor.clear;
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        return imageView;
    }()
    
    
    public func imageViewEmailConstraints()
    {
        imageViewEmail.anchor(top: containerView.topAnchor, leading: nil, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 8), size: .init(width: 100, height: 100));
    }
 
    public func userMessageConstraints()
    {
        userMessageBox.anchor(top: userInfoStackView.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 10, left: 8, bottom: 0, right: 8), size: .init(width: 300, height: 40));
        //userMessageBox.backgroundColor = hexStringToUIColor(hex: "#20AEE1");
        userMessageBox.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor.black, width: 0.5);
    }
    
    var supportLabel : UILabel = {
        let label = UILabel();
        label.text = "Support";
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 35.0);
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 60);
        return label;
    }()
    
    public func supportLableConstraints()
    {
        supportLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: containerView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 300, height: 60));
        supportLabel.textColor = hexStringToUIColor(hex: colorBLUE);
    }
    
    
    var containerView : UIView = {
        let view = UIView();
        view.layer.borderWidth = 1;
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor;
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowOffset = CGSize(width: -1, height: 1);
        view.layer.shadowRadius = 3;
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400);
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.layer.cornerRadius = 10;
        return view;
    }()
    
    func constraints()
    {
        containerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -40).isActive = true;
        containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true;
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true;
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true;
        containerView.heightAnchor.constraint(equalToConstant: 330).isActive = true;
        let color = hexStringToUIColor(hex: "#828282");
        containerView.layer.borderColor = color.cgColor;
        containerView.backgroundColor = hexStringToUIColor(hex: colorWHITE);
    }
    
    
    var userInfoStackView : UIStackView = {
        let stackView = UIStackView();
        stackView.axis  = NSLayoutConstraint.Axis.vertical;
        stackView.distribution  = UIStackView.Distribution.equalSpacing;
        stackView.alignment = UIStackView.Alignment.leading;
        stackView.spacing   = 10.0;
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        return stackView;
    }()
    
    var stackNameInput : UITextField = {
        let name = UITextField();
        name.text = "Name";
        name.keyboardType = UIKeyboardType.default;
        name.returnKeyType = UIReturnKeyType.done;
        name.font = UIFont(name: "HelveticaNeue", size: 16);
        name.clearButtonMode = UITextField.ViewMode.whileEditing;
        name.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        name.textColor = UIColor.black;
        return name;
        
    }()
    var stackEmailInput : UITextField = {
        let email = UITextField();
        email.frame = CGRect(x: 0, y: 0, width:400, height: 40);
        email.text = "Email";
        email.keyboardType = UIKeyboardType.default;
        email.returnKeyType = UIReturnKeyType.done;
         email.font = UIFont(name: "HelveticaNeue", size: 16)
        email.clearButtonMode = UITextField.ViewMode.whileEditing;
        email.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        email.textColor = UIColor.black;
        return email;
        
    }()
    var stackSubjectInput : UITextField = {
        let subject = UITextField();
        subject.frame = CGRect(x: 0, y: 0, width: 400, height: 40);
        subject.text = "Subject";
        subject.font = UIFont(name: "HelveticaNeue", size: 16);
        subject.keyboardType = UIKeyboardType.default;
        subject.textColor = UIColor.black;
        subject.returnKeyType = UIReturnKeyType.done;
        subject.clearButtonMode = UITextField.ViewMode.whileEditing;
        subject.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return subject;
        
    }()
    
    var userMessageBox : UITextField = {
        let textView = UITextField();
        textView.returnKeyType = UIReturnKeyType.done;
        textView.text = "Message here";
        textView.font = UIFont(name: "HelveticaNeue", size: 16);
        textView.keyboardType = UIKeyboardType.default;
        textView.returnKeyType = UIReturnKeyType.done;
        textView.clearButtonMode = UITextField.ViewMode.whileEditing;
        textView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center;
        textView.textColor = UIColor.black;
        textView.translatesAutoresizingMaskIntoConstraints = false;
        return textView;
    }()
    
    func stackViewAndViews_C()
    {
        stackNameInput.textColor = hexStringToUIColor(hex: colorLIGHT_GRAY);
        stackEmailInput.textColor = hexStringToUIColor(hex: colorLIGHT_GRAY);
        stackSubjectInput.textColor = hexStringToUIColor(hex: colorLIGHT_GRAY);
        userMessageBox.textColor = hexStringToUIColor(hex: colorPINK);
        stackNameInput.delegate = self;
        stackEmailInput.delegate = self;
        stackSubjectInput.delegate = self;
        stackNameInput.widthAnchor.constraint(equalToConstant: 220).isActive = true;
        stackEmailInput.widthAnchor.constraint(equalToConstant: 220).isActive = true;
        stackSubjectInput.widthAnchor.constraint(equalToConstant: 220).isActive = true;
        userInfoStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true;
        userInfoStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true;
        userInfoStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true;
        userInfoStackView.widthAnchor.constraint(equalToConstant: 220).isActive = true;
        stackNameInput.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 0.5);
        stackEmailInput.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 0.5);
        stackSubjectInput.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 0.5);
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

extension UIView {
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
