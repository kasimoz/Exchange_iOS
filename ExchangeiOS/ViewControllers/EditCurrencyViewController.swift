//
//  EditCurrencyViewController.swift
//  ExchangeiOS
//
//  Created by KasimOzdemir on 6.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import UIKit

class EditCurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currencies : Dictionary<String,Any>!
    var currenciesArray : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencies = self.getAllCurrenciesDict()
        self.currenciesArray = Array(self.currencies.keys).sorted(by: <)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tintColor = .label
        return self.currenciesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let flag = cell?.viewWithTag(1) as? UIImageView
        let code = cell?.viewWithTag(2) as? UILabel
        let name = cell?.viewWithTag(3) as? UILabel
        let values = self.currencies?[self.currenciesArray[indexPath.row]] as? Dictionary<String,Any>
        flag?.image = UIImage.init(named: values!["Image"] as! String)
        code?.text = self.currenciesArray[indexPath.row]
        name?.text = values!["Name"] as? String
        if self.getCurrenciesArray().contains(self.currenciesArray[indexPath.row]){
            cell?.accessoryType = .checkmark
        }else{
            cell?.accessoryType = .none
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                var array = self.getCurrenciesArray()
                let index = array.firstIndex(of: self.currenciesArray[indexPath.row])!
                array.remove(at: index)
                self.setCurrenciesArray(array: array)
            }else{
                cell.accessoryType = .checkmark
                var array = self.getCurrenciesArray()
                array.append(self.currenciesArray[indexPath.row])
                self.setCurrenciesArray(array: array)
            }
        }
        // Reload base tableView with new choices
        NotificationCenter.default.post(name: NSNotification.Name("ReloadTableView"), object: nil)
    }
}
