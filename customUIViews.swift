//
//  customUIViews.swift
//  VeganApp
//
//  Created by Luis Gonzalez on 9/22/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit




class customUIViews: UIView {
    
    var mainUIView = UIView();
    var name: String;
    var image: String;
    var descrip:String;
    
    override init(frame: CGRect) {
        
        self.mainUIView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height);
        super.init(frame: frame);
    }

    init(name : String, image: String, desc: String) {
        self.name = name;
        self.image = image;
        self.descrip = desc;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
}
