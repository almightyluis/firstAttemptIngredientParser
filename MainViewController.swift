//
//  ViewController.swift
//  VeganApp
//
//  Created by Luis Gonzalez on 8/3/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//


// this is the main color for this app
//#AEE120


/*
 feature(1)
 Double tap
 Turn on flash.
 FINISHED
 */



// TO DO//////////////////
/*
UIView to announce that we have feature (1)
 */
/*
 CHANGE SCANNER
 */

import UIKit
import AVFoundation

class MainViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var viewContrller = UIViewController();
    var video = AVCaptureVideoPreviewLayer();
    var scanner:String? = nil;
    var scannerManual:String? = nil;
    var scannerArray = [String]();
    let session = AVCaptureSession();
    @IBOutlet var button: UIButton!
    
    let colorPINK: String = "#E1204D";
    let colorGREEN: String = "#8CB618";
    let colorBLUE: String = "#20AEE1";
    let colorWHITE: String = "#ffffff";
    let colorLIGHT_GRAY: String = "#919191";
    
    lazy var buttonContainer : UIView = {
        var container = UIView();
        container.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
        container.backgroundColor = UIColor.white;
        container.layer.cornerRadius = 50;
        container.layer.masksToBounds = true;
        container.translatesAutoresizingMaskIntoConstraints = false;
       return container;
    }()
    
    lazy var doubleTapGesture: UITapGestureRecognizer = {
      var gesture = UITapGestureRecognizer(target: self, action: #selector(toggleFlash));
      gesture.numberOfTapsRequired = 2;
      return gesture;
    }()
    
    lazy var viewToAnimate : UIView = {
        var view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 40);
        return view;
    }()
    
    lazy var messageTextView:  UITextView = {
        var textView = UITextView();
        textView.translatesAutoresizingMaskIntoConstraints = false;
        textView.text = "Double tap for flashlight";
        textView.isSelectable = false;
        textView.font = UIFont(name: "Helvetica-Light", size: 10);
        textView.isEditable = false;
        textView.textAlignment = .center;
        textView.backgroundColor = UIColor.clear;
        return textView;
    }()
    
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad();
        startVideoSession();
        buttonStyle();
        toolbarColor();
        userListButton();
        navigationItem.rightBarButtonItem = settingsButton();
        view.addSubview(buttonContainer);
        view.isUserInteractionEnabled = true;
        view.addGestureRecognizer(doubleTapGesture);
        buttonContainerConstraints();
        view.addSubview(viewToAnimate);
        viewToAnimate.addSubview(messageTextView);
        viewToAnimateContraints();
        messageConstraints();
    }
    
    private func userListButton()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "listIcon"), style: .plain, target: self, action: #selector(showCurrentList));
    }
    
    
    @objc private func showCurrentList()
    {
        // add seque to userListController
    }
    
    private func messageConstraints()
    {
        messageTextView.topAnchor.constraint(equalTo: viewToAnimate.topAnchor).isActive = true;
        messageTextView.bottomAnchor.constraint(equalTo: viewToAnimate.safeAreaLayoutGuide.bottomAnchor).isActive = true;
        messageTextView.leadingAnchor.constraint(equalTo: viewToAnimate.leadingAnchor).isActive = true;
        messageTextView.trailingAnchor.constraint(equalTo: viewToAnimate.trailingAnchor).isActive = true;
        messageTextView.textColor = hexStringToUIColor(hex: colorPINK);
    }
    private func viewToAnimateContraints()
    {
        viewToAnimate.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5).isActive = true;
        viewToAnimate.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        viewToAnimate.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        viewToAnimate.heightAnchor.constraint(equalToConstant: 35).isActive = true;
        
    }

    @objc func addTapped(sender: UIBarButtonItem) {
        launchSettings();
        turnOffTorch();
    }
    // when called back this will start our session back
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        session.startRunning();
        toolbarColor();
        buttonContainerConstraints();
    }
    
    @objc func toggleFlash()
    {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {return }
        guard device.hasTorch else {return }
        do{
            try device.lockForConfiguration()
            if(device.torchMode == AVCaptureDevice.TorchMode.on)
            {
                device.torchMode = AVCaptureDevice.TorchMode.off;
            }
            else
            {
                do{
                    try device.setTorchModeOn(level: 1.0)
                }
                catch{
                    print("Error on torch mode");
                }
            }
            device.unlockForConfiguration()
        }catch{
            print(error, "Last loop");
        }
    }
    
    private func turnOffTorch()
    {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {return }
        guard device.hasTorch else {return }
        do{
            try device.lockForConfiguration()
            if(device.torchMode == AVCaptureDevice.TorchMode.on)
            {
                device.torchMode = AVCaptureDevice.TorchMode.off;
            }
            device.unlockForConfiguration()
        }catch{
            print(error, "Last loop");
        }
    }
    
    public func toolbarColor()
    {
        self.navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: colorWHITE);
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationItem.title = "Scanner";
        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: colorPINK);
    }
    
    func buttonContainerConstraints()
    {
        buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true;
        buttonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true;
        
    }
    
    public func settingsButton()->UIBarButtonItem
    {
        let image = UIImage(named: "settings");
        let button = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(addTapped));
        return button;
    }
    
    // on click launch AlertDiolog
    // OK - > Launches new ViewController -> might need to add checks to make sure its of right lenght;
    // cancel - > Dismiss the alert;
    // removes torch if on
    @IBAction func onButtonClick(_ sender: Any)
    {
        let dialog = UIAlertController(title: "Enter Barcode Manually", message: "Enter : ", preferredStyle: .alert);
        dialog.addTextField(configurationHandler: { (textField)
            in textField.text = "";
            textField.keyboardType = .numberPad;
        })
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak dialog] (_) in
            let textField = dialog?.textFields![0];// Force unwrapping because we know it exists.
            if((textField?.text!.isEmpty)!)
            {
                self.showErrorMessage(message: "Text field is empty!");
                return;
            }
            else
            {
                // if nill abort newScreen
                self.scannerManual = textField?.text;
                self.launchViewManual(str: self.scannerManual!);
                print("Text field: \(String(describing: textField?.text))")}
            }
        ));
        // Cancel button
        dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
        self.present(dialog, animated: true, completion: nil);
        turnOffTorch();
    }
    
    func showErrorMessage(message: String)
    {
        let errorDialog = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert);
        errorDialog.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
        self.present(errorDialog, animated: true, completion: nil);
    }
    
    
    func buttonStyle()
    {
        let imageWidth = UIImage(named: "code")?.size.width;
        button.layer.cornerRadius = 15;
        button.backgroundColor = hexStringToUIColor(hex: "#d4d4d1");
        button.tintColor = UIColor.white;
        button.widthAnchor.constraint(equalToConstant: imageWidth! as CGFloat).isActive = true;
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true;
        
    }
    // Start video Session
    // also brings Button view & ImageView to the front of the View stack
    private func startVideoSession()
    {
        
        guard let capture = AVCaptureDevice.default(for: .video ) else {
            print("No Media")
            return;
        }
        do
        {
            guard let input = try? AVCaptureDeviceInput(device: capture) else
            {
                print("Error");
                return;
            }
            session.addInput(input);
        }
        
        let output = AVCaptureMetadataOutput();
        session.addOutput(output);
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main);
        output.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417];
        video = AVCaptureVideoPreviewLayer(session: session);
        video.frame = view.layer.bounds
        view.layer.addSublayer(video);
        self.view.bringSubviewToFront(button);
        self.view.bringSubviewToFront(imageView);
    
        session.startRunning();
    }
     
  
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        if (metadataObjects != nil && metadataObjects.count != nil)
        {
            if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject
            {
                if (object.type == .ean8 || object.type == .pdf417 || object.type == .upce)
                {
                    gatherInformation(strBarcode: object.stringValue!);
                }
                else if(object.type == .ean13 )
                {
                    let dropExtraStr = object.stringValue!.dropFirst();
                    gatherInformation(strBarcode: String(dropExtraStr));
                   
                    
                    
                }
                else if(object.type == .qr)
                {
                    let error = UIAlertController(title: "Sorry we dont support QR codes yet :(", message: "Try later once we update this app.", preferredStyle: .alert);
                    let action = UIAlertAction(title: "Close", style: .cancel, handler: nil);
                    error.addAction(action);
                }
                else
                {
                    let errorAlert = UIAlertController(title: "We could not recognize that barcode", message: "Try again later", preferredStyle: .alert);
                    errorAlert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil));
                    self.present(errorAlert, animated: true, completion: nil);
                }
            }
        }
        
    }
    
    // stops the porcess of camera from gathering more UPCS
    // launches newView;
    private func gatherInformation(strBarcode: String)
    {
        /// this is adding a zero up front so we might need to remove this or maybe increase the accuracy by allowing more than one
        // scan to go through in the array.!!
        scanner = strBarcode;
        session.stopRunning();
        launchNewView();
    }

    public func launchViewManual(str: String)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "secondVC") as? SecondViewController;
        vc?.barcode = str;
        self.navigationController?.pushViewController(vc!, animated: true);
        print("Manual Launch");
        return;
    }

    // this is fine for now fix the N times of execusion.
    public func launchNewView()
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "secondVC") as? SecondViewController;
        vc?.barcode = scanner!;
        self.navigationController?.pushViewController(vc!, animated: true);
        print("AutoLaunch");
        return;
    }
    
    
    // this us where we change settings
    public func launchSettings()
    {
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "contactVc") as? supportPage;
        self.navigationController?.pushViewController(viewController!, animated: true);
        print("Launched Settings");
        return;
    }

    
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning();
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
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




