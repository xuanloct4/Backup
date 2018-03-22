//
//  Utils.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 4/18/17.
//  Copyright © 2017 jefby. All rights reserved.
//

import UIKit

extension String {
    func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    var localized: String {
        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
            // we set a default, just in case
            UserDefaults.standard.set("en", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
        }
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
 }

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst()).lowercased()
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    //    subscript (r: Range<Int>) -> String {
    //        let start = startIndex.advancedBy(r.startIndex)
    //        let end = start.advancedBy(r.endIndex - r.startIndex)
    //        return self[Range(start ..< end)]
    //    }
}

@objc
class Utils:NSObject
{
    class func stringFromIndex(_ index:Int, status: [String:Bool]!) -> String
    {
        let keys:[String] = [String](status.keys)
        return keys[index]
    }
    
    class func boolFromIndex(_ index:Int, status: [String:Bool]!) -> Bool
    {
        let keys:[String] = [String](status.keys)
        let key = keys[index]
        return status[key]!
    }
    
    
    class func copyArray<V>(_ array:[V]!) -> [V]!
    {
        var copy:[V] = [V]()
        guard array.count > 0 else {
            return copy
        }
        
        for item in array {
            let i:V = item
            copy.append(i)
        }
        
        return copy
    }
    
    class func copyArrayCopying<V:NSCopying>(_ array:[V]!) -> [V]!
    {
        var copy:[V] = [V]()
        guard array.count > 0 else {
            return copy
        }
        
        for index in 0..<array.count
        {
            let it:V = array[index]
            let i:V = it.copy() as! V
            copy.append(i)
        }
        
        //        for item in array {
        //            let i:V = item
        //            copy.append(i)
        //        }
        
        return copy
    }
    
    class func copyDictionary<V,U>(_ dict:[V:U]!) -> [V:U]!
    {
        var copy:[V:U] = [V:U]()
        guard dict.count > 0 else {
            return copy
        }
        
        let keys:[V] = [V](dict.keys)
        
        for key in keys {
            copy[key] = dict[key]
        }
        
        return copy
    }
    
    class func copyDictionaryCopying<V,U:NSCopying>(_ dict:[V:U]!) -> [V:U]!
    {
        var copy:[V:U] = [V:U]()
        guard dict.count > 0 else {
            return copy
        }
        
        let keys:[V] = [V](dict.keys)
        
        for index in 0..<keys.count
        {
            let key:V = keys[index]
            let it:U = dict[key]!
            let i:U = it.copy() as! U
            copy[key] = i
        }
        
        return copy
    }
    
    class func indexOfString(_ array:[String]!, text:String!,caseInsensitive:Bool)->Int
    {
        guard array.count > 0 else {
            return -1
        }
        for index in 0..<array.count{
            if (caseInsensitive){
                if(text.uppercased() == array[index].uppercased())
                {
                    return index
                }
            }else{
                if(text == array[index])
                {
                    return index
                }
            }
        }
        return -1
    }
    
    class func convert12To24(_ date: Date) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "hh:mm"
        let time24String = dateFormatter.string(from: date)
        let time24 = dateFormatter.date(from: time24String)
        return time24
    }
    
    class func getMinute(_ time12h: Date) ->Int
    {
        let time24String = (Calendar.current as NSCalendar).component(.minute, from: time12h)
        return time24String
    }
    
    
    
    class func getHour(_ time12h: Date) ->Int?
    {
        let time24String = (Calendar.current as NSCalendar).component(.hour, from: time12h)
        return time24String
    }
    
    class func convertStringDateFormater(_ date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        if let convertedDate = dateFormatter.date(from: date){
            return convertedDate
        }else{
            return Date()
        }
        
    }
    
    class func convertDateStringFormater(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: date)
    }
    
    class func convertDecimalToBinary(_ num:Int, toSize:Int)-> String{
        var str = String.init(num, radix: 2)
        //        var padded = string
        for _ in 0..<(toSize - str.characters.count) {
            str = "0" + str
        }
        return str
    }
    
    class func convertBinaryToBoolArray(_ binString:String)-> [Bool] {
        var boolAray:[Bool] = []
        for index in 0..<binString.characters.count{
            let character:String = binString[index]
            if(character == "0"){
                boolAray.append(false)
            }else{
                boolAray.append(true)
            }
        }
        return boolAray
    }
    
    class func convertBoolArrayToBinary(_ boolArray:[Bool])->String {
        var binString = ""
        for index in 0..<boolArray.count {
            if(boolArray[index] == true){
                binString = "\(binString)1"
            }else{
                binString = "\(binString)0"
            }
        }
        return binString
    }
    
    class func convertBinaryToDecimal(_ binString:String)-> Int{
        let num = strtoul(binString, nil, 2)
        return Int(num)
    }
    
    class func convertDecimalToBinary(_ decString:String)-> Int{
        let num = strtoul(decString, nil, 10)
        return Int(num)
    }
    
    //    class func updateValue(value:Bool, inout dictionary:[String:Bool], index:Int)
    //    {
    //        let keys:[String] = [String](dictionary.keys)
    //        let key = keys[index]
    //        dictionary[key] = value
    //    }
    //
    //    class func updateValue(values:[Bool], inout dictionary:[String:Bool])
    //    {
    //        let keys:[String] = [String](dictionary.keys)
    //        for ind in 0..<keys.count {
    //        let key = keys[ind]
    //            dictionary[key] = values[ind]
    //        }
    //    }
}
