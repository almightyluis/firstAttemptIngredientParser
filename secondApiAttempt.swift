//
//  secondApiAttempt.swift
//  VeganApp
//
//  Created by Luis Gonzalez on 12/27/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation



struct rootData: Codable
{
    let products: [list];
}
struct list: Codable
{
    let barcode_number: String;
    let product_name: String;
    let brand: String;
    let ingredients: String;
}


class secondApiAttempt: JSONDecoder {
    
    var name_data: String = "";
    var barcode_data: String = "";
    var ingredient_data: String = "";
    var brand_data: String = "";
    
    private var barcode:String = "";
    private var ZERO_ITERATOR: Int = 0;
    private var APIKEY:String = "&key=qy6xoh9q4nox80abpogly3pexjwoxw";
    private var valuesToReturn = NSMutableArray();
    private var link:String = "https://api.barcodelookup.com/v2/products?barcode=";
    
    init(userBarcode : String) {
        self.barcode = link+userBarcode+APIKEY;
    }
    deinit {
        self.valuesToReturn.removeAllObjects();
    }
    
    
    // Error 1 -> Incorrect UPC
    // Error 0-> Ok
    public func attemptGet()
    {
        if (barcode.isEmpty)
        {
            print("BARCODE IS EMPTY");
            return ;
        }
        
        guard let m_URL = URL(string: self.barcode) else {return ;}
       
        let session = URLSession.shared;
        session.dataTask(with: m_URL)
        { (data, response, error) in

            if let response = response as? HTTPURLResponse, response.statusCode != 200
            {
                print("secondApiAttempt Responce",response);
            }
            if let data = data
            {
                do
                {
                    let decodable = JSONDecoder();
                    let product = try decodable.decode(rootData.self, from: data);
                    self.gatherData(data: product);
                }
                catch
                {
                    print(error);
                }
            }
            if let error = error
            {
                print("Error First Attemp", error.localizedDescription);
                
            }
            
            }.resume();
    }
    
    private func gatherData(data: rootData)
    {
        self.name_data = data.products[0].product_name;
        self.barcode_data = data.products[0].barcode_number;
        self.ingredient_data = data.products[0].ingredients;
        self.brand_data = data.products[0].brand;
    }
  
    
    
    
    
    
    
    
    
}
