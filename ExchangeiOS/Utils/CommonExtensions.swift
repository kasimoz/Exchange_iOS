//
//  CommonExtensions.swift
//  ExchangeiOS
//
//  Created by KasimOzdemir on 7.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func getAllCurrenciesDict() ->  Dictionary<String,Any>{
        let path = Bundle.main.path(forResource: "Currencies", ofType: "plist")!
        let nsDictionary = NSDictionary(contentsOfFile: path)
        let currencies = nsDictionary as? Dictionary<String,Any>
        return currencies!
    }
    
    func getAllCurrencies() ->  [String]{
        let currencies = self.getAllCurrenciesDict()
        let currenciesArray = Array(currencies.keys).sorted(by: <)
        return currenciesArray
    }
    
    func setWidgetBase(value : String){
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        userDefaults?.set(value, forKey: "WidgetBase")
    }
    func getWidgetBase() ->  String {
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        if self.isKeyPresentInUserDefaults(key: "WidgetBase") {
            return (userDefaults?.string(forKey: "WidgetBase"))!
        }else{
            return "USD"
        }
    }
    
    func setWidgetFirst(value : String){
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        userDefaults?.set(value, forKey: "WidgetFirst")
    }
    func getWidgetFirst() ->  String {
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        if self.isKeyPresentInUserDefaults(key: "WidgetFirst") {
            return (userDefaults?.string(forKey: "WidgetFirst"))!
        }else{
            return "TRY"
        }
    }
    
    func setWidgetSecond(value : String){
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        userDefaults?.set(value, forKey: "WidgetSecond")
    }
    func getWidgetSecond() ->  String {
           let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        if self.isKeyPresentInUserDefaults(key: "WidgetSecond") {
            return (userDefaults?.string(forKey: "WidgetSecond"))!
        }else{
            return "EUR"
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        return userDefaults!.object(forKey: key) != nil
    }
}
