//
//  ObjectData .swift
//  VeganApp
//
//  Created by Luis Gonzalez on 8/11/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation

class parseIngredient
{
    
    
    
    // since we remove most of what is possible using my own method
    // I can finally iterate each nth term and remove any special characters to make it look better.
    // Other Feature--> Add a save barcode Feature.
    
    
    private var ingredients:String = "";
    init(ingredient: String)
    {
        self.ingredients = ingredient;
    }
    
    private func typeSeperator()->Int
    {
        let cc = ingredients.components(separatedBy: ",");
        let ss = ingredients.components(separatedBy: ";");
        if(cc.count > ss.count)
        {return 1;} else {return 2;}
        
    }
    
    // if false then we do need to parse
    // if true then we dont need to parse
    private func checkIfNeeded()->Bool
    {
        let arrayCheck = ingredients.components(separatedBy: ",");
        for i in 0..<arrayCheck.count
        {
            if(arrayCheck[i].contains("(") || arrayCheck.contains("[") || arrayCheck.contains("{"))
            {
                return false;
            }
        }
        return true;
    }
    
    
    private func returnInnerValues()->[String]
    {
        var stringArrayReturn = [String]();
        let completeIngredientString = self.ingredients.components(separatedBy: " ");
        for var i in 0..<completeIngredientString.count
        {
            if(completeIngredientString[i].contains("("))
            {
                repeat
                {
                    stringArrayReturn.append(completeIngredientString[i]);
                    i+=1;
                    if(completeIngredientString.count == i)
                    {
                        stringArrayReturn.append(completeIngredientString[i-1]);
                        return stringArrayReturn;
                    }
                }while(!completeIngredientString[i].contains(")"));
                stringArrayReturn.append(completeIngredientString[i]);
                continue;
            }
        }
        return stringArrayReturn;
    }
    
    private func stringBuilder()->[String]
    {
        var stringBuilder:String = "";
        
        for i in 0..<returnInnerValues().count
        {
            stringBuilder += " " + returnInnerValues()[i];
        }
        var finalTrimmed = stringBuilder.components(separatedBy: ",");
        
        for i in 0..<finalTrimmed.count
        {
            if(finalTrimmed[i].contains("("))
            {
                let value = finalTrimmed[i].replacingOccurrences(of: "(", with: "");
                finalTrimmed[i] = value;
                continue;
            }else if(finalTrimmed[i].contains(")"))
            {
                let value = finalTrimmed[i].replacingOccurrences(of: ")", with: "");
                finalTrimmed[i] = value;
                continue;
            }
            else if(finalTrimmed[i].contains("["))
            {
                let value = finalTrimmed[i].replacingOccurrences(of: "[", with: "");
                finalTrimmed[i] = value;
                continue;
            }else if(finalTrimmed[i].contains("]"))
            {
                let value = finalTrimmed[i].replacingOccurrences(of: "]", with: "");
                finalTrimmed[i] = value;
                continue;
            }
            else if (finalTrimmed[i].contains("{"))
            {
                let value = finalTrimmed[i].replacingOccurrences(of: "{", with: "");
                finalTrimmed[i] = value;
                continue;
            }
            else if(finalTrimmed[i].contains("}"))
            {
                let value = finalTrimmed[i].replacingOccurrences(of: "}", with: "");
                finalTrimmed[i] = value;
                continue;
            }
            else
            {
                continue;
            }
        }
        return finalTrimmed;
        
    }
    
    // return without ()
    private func parseOutParentisis()->String
    {
        let trimmedString = ingredients.replacingOccurrences(of: "\\((.*?)\\)", with: "", options: .regularExpression);
        return trimmedString;
    }
    
    public func returnIngredientList()->[String]
    {
        // look ahead if we need to parse differently!
        switch typeSeperator() {
        case 1:
            if(checkIfNeeded())
            {
                var regularParse = ingredients.components(separatedBy: ",");
                for i in 0..<regularParse.count
                {
                    regularParse[i] = regularParse[i].uppercased();
                }
                return regularParse;
            }
            else
            {
                var listToReturn = parseOutParentisis().components(separatedBy: ",");
                let finalEdit = stringBuilder();
                
                if (self.ingredients.isEmpty)
                {
                    listToReturn[0] = "Empty Error";
                    return listToReturn;
                }
                for i in 0..<finalEdit.count
                {
                    listToReturn.append(finalEdit[i]);
                }
                
                for i in 0..<listToReturn.count
                {
                    listToReturn[i] = listToReturn[i].uppercased();
                }
                return listToReturn;
            }
        case 2:
            var listToReturn = parseOutParentisis().components(separatedBy: ";");
            let finalEdit = stringBuilder();
            
            if (self.ingredients.isEmpty)
            {
                listToReturn[0] = "Empty Error";
                return listToReturn;
            }
            for i in 0..<finalEdit.count
            {
                listToReturn.append(finalEdit[i]);
            }
            
            for i in 0..<listToReturn.count
            {
                listToReturn[i] = listToReturn[i].uppercased();
            }
            return listToReturn;
        default:
            let listToReturn = parseOutParentisis().components(separatedBy: " ");
            return listToReturn;
        }
    }
}
