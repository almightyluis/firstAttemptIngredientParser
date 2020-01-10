//
//  userListController.swift
//  VeganApp
//
//  Created by Luis Gonzalez on 12/23/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit


class userViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var sampleArray: NSArray = ["First", "Second", "Third"];
    
   
    lazy var currentTable : UITableView = {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let table = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight));
        table.delegate = self;
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell");
        table.dataSource = self;
        return table;
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        view.addSubview(currentTable);
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
           cell.textLabel!.text = "\(sampleArray[indexPath.row])"
           return cell
       }
    
}
