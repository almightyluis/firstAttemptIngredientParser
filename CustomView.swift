//
//  CustomView.swift
//  VeganApp
//
//  Created by Luis Gonzalez on 9/25/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit


class CustomView : UIView {
    
    var imageView = UIImageView();
    var containerName = UILabel();
    var textView = UITextView();
    
    let name:String;
    let desc:String;
    let imagePathStr:String;
   
    

    required init(coder aDecoder: NSCoder)
    {
        fatalError("This class does not support NSCoding");
    }
    
    init(name: String?, description: String?, imagePath: String?, frame : CGRect) {
        self.name = name!;
        self.desc = description!;
        self.imagePathStr = imagePath!;
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 160));
        self.setValuesForView();
        self.addBehavior();
    }
    
    public func setValuesForView()
    {
        containerName.translatesAutoresizingMaskIntoConstraints = false;
        containerName.text = name;
        containerName.font = UIFont.systemFont(ofSize: 13);
        containerName.textColor = UIColor.white;
        containerName.frame = CGRect(x: 0, y: 0, width: layer.bounds.width, height: 18);
        
        imageView.image = UIImage(named: imagePathStr);
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.backgroundColor = UIColor.clear;
        imageView.contentMode = .center;
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50);
        
        textView.translatesAutoresizingMaskIntoConstraints = false;
        textView.text = self.desc;
        textView.isEditable = false;
        textView.isSelectable = true;
        textView.textAlignment = .center;
        textView.scrollRangeToVisible(NSMakeRange(0, 0));
        textView.contentOffset = .zero;
        textView.font = UIFont.systemFont(ofSize: 11);
        textView.textColor = UIColor.black;
        textView.backgroundColor = UIColor.white;
        textView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height);
        [containerName, imageView, textView].forEach{addSubview($0)}
        constraintsForValues()
    }
   
    
    func addBehavior()
    {
        translatesAutoresizingMaskIntoConstraints = false;
        widthAnchor.constraint(equalToConstant: 200).isActive = true;
        heightAnchor.constraint(equalToConstant: 160).isActive = true;
        let color = hexStringToUIColor(hex: "#E1204D").cgColor;
        layer.cornerRadius = 5.0;
        layer.borderWidth = 0.5;
        layer.masksToBounds = true;
        layer.borderColor = color;
        backgroundColor = hexStringToUIColor(hex: "#8CB618");
    
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
    
    func constraintsForValues()
    {
        textView.topAnchor.constraint(equalTo: containerName.bottomAnchor, constant: 2).isActive = true;
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true;
        textView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true;
        
        containerName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true;
        containerName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true;
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true;
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true;
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true;
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true;
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true;
    }
    
    
}

