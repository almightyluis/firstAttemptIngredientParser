//
//  easyBoxes.swift
//  VeganApp
//
//  Created by Luis Gonzalez on 9/15/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit


class easyBoxes : UIView
{
    public var name: String = "";
    public var description:[String] = nil;
    public var image:String = "";
    public var boxes: UIView;
    
    init(view : UIView) {
        
    }
    init(name: String, descArray: [String], image: String) {
        self.name = name;
        self.description = descArray;
        self.image = image;
    }
    
    
    
}
