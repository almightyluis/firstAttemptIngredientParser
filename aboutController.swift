//
//  aboutController.swift
//  VeganApp
//
//  Created by Luis Gonzalez on 12/21/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit


class aboutController: UIViewController {
    
    let width = (UIScreen.main.bounds.width / 1.5);
    let height = UIScreen.main.bounds.height;
    override func viewDidLoad() {
        super.viewDidLoad();
        view.addSubview(centerView);
        centerViewConstraints();
    }
    
    var centerView: UIView = {
        let mainView = UIView();
        mainView.backgroundColor = UIColor.orange;
        mainView.layer.borderWidth = 0.5;
        mainView.layer.borderColor = (UIColor.black).cgColor;
        return mainView;
    }()
    
    private func centerViewConstraints()
    {
        centerView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 20, bottom: 5, right: 20), size: .init(width: width, height: height));
        centerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
    }
    
    
    
    
}

/*
 
 Credit to
 ICONS: https://icons8.com/icons/set/about-ios
 ICON BUILDER: https://makeappicon.com/download/93b9aa7c602e4b278eafebdfa3aed6f5
 LEAD SF : Luis Gonzalez
 MAIN ICON PIC : by Freepik , Sat-21-2019 Commercial Use: OK.
 http://www.iconsalot.com/show/gardening-28-by-freepik/009-leaf-icon.html
 
 
 */
