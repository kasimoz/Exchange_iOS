//
//  UiExtensions.swift
//  ExchangeiOS
//
//  Created by KasimOzdemir on 6.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func rounded(_ digits:Int) -> Double {
        let divisor = pow(10.0, Double(digits))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    func toDate(format : String = "dd MMM") -> String {
        guard !self.isEmpty else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

extension Date {
    func toString(format : String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func addingDay(_ value : Int)-> Date {
        return self.addingTimeInterval(TimeInterval(value * 24 * 60 * 60))
    }
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension UIColor {
    convenience init(_ hexString: String, alpha: CGFloat = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
    }
    
    
    public func setOpacity(_ opacity: CGFloat) -> UIColor {
        
        let rgb = self.cgColor.components
        return UIColor(red: rgb![0], green: rgb![1], blue: rgb![2], alpha: opacity)
        
    }
}

extension UIViewController {
    
    func viewTouch (){
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.touchAction))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func touchAction(sender : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func setBaseCurrency(code : String , name : String, symbol :String){
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        userDefaults?.set(code, forKey: "BaseCode")
        userDefaults?.set(name, forKey: "BaseName")
        userDefaults?.set(symbol, forKey: "BaseSymbol")
    }
    
    func getBaseCurrency() ->  [String] {
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        if self.isKeyPresentInUserDefaults(key: "BaseCode") {
            return [(userDefaults?.string(forKey: "BaseCode"))!, (userDefaults?.string(forKey: "BaseName"))!, (userDefaults?.string(forKey: "BaseSymbol"))!]
        }else{
            return ["USD", "United States Dollar","$"]
        }
    }
    func setCurrenciesArray(array :  [String]){
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        userDefaults?.set(array, forKey: "CurrenciesArray")
    }
    
    func getCurrenciesArray() ->  [String] {
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        if self.isKeyPresentInUserDefaults(key: "CurrenciesArray") {
            return (userDefaults?.array(forKey: "CurrenciesArray") as! [String]).sorted(by: <)
        }else{
            return self.getAllCurrencies()
        }
    }
    
    func setDefaultFrom(from : String){
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        userDefaults?.set(from, forKey: "From")
    }
    
    func getDefaultFrom() ->  String {
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        if self.isKeyPresentInUserDefaults(key: "From") {
            return (userDefaults?.string(forKey: "From"))!
        }else{
            return "USD"
        }
    }
    
    func setDefaultTo(to : String){
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        userDefaults?.set(to, forKey: "To")
    }
    func getDefaultTo() ->  String {
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        if self.isKeyPresentInUserDefaults(key: "To") {
            return (userDefaults?.string(forKey: "To"))!
        }else{
            return "TRY"
        }
    }
    
    func setLatestRequestTime(_ time : Int64){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(String.init(time), forKey: "LatestRequestTime")
        }
    }
    
    func getLatestRequestTime() -> Int64 {
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            if let time = userDefaults.string(forKey: "LatestRequestTime") {
                return Int64.init(time)!
            }
            return Date().millisecondsSince1970
        }
        return Date().millisecondsSince1970
    }
    
    func setLatest(_ latest : Latest){
       let userDefaults = UserDefaults(suiteName: Contants.suiteName)
       userDefaults?.setValue(latest.toJSON(), forKey: "Latest")
    }
    
    func getLatest() -> Latest {
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        if let dict = userDefaults?.dictionary(forKey: "Latest") {
            return Latest.init(JSON: dict)!
        }
        return Latest.init()
    }
    
    func saveLastChart(_ history : History){
       let userDefaults = UserDefaults(suiteName: Contants.suiteName)
       userDefaults?.setValue(history.toJSON(), forKey: "History")
    }
    
    func getLastChart() -> History {
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        if let dict = userDefaults?.dictionary(forKey: "History") {
            return History.init(JSON: dict)!
        }
        return History.init()
    }
    
    
    func customPickerViewController(array : [String]){
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomPickerView") as! CustomPickerView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self as! CustomPickerViewDelegate
        customAlert.array = array
        self.present(customAlert, animated: true, completion: nil)
    }
}
