//
//  SettingsViewController.swift
//  ExchangeiOS
//
//  Created by KasimOzdemir on 7.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, CustomPickerViewDelegate {
    

    @IBOutlet weak var baseCurrency: UILabel!
    @IBOutlet weak var fromCurrency: UILabel!
    @IBOutlet weak var toCurrency: UILabel!
    @IBOutlet weak var widgetBaseCurrency: UILabel!
    @IBOutlet weak var widgetFirstCurrency: UILabel!
    @IBOutlet weak var widgetSecondCurrency: UILabel!
    var selectedIndex : IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.baseCurrency.text = self.getBaseCurrency()[0]
        self.fromCurrency.text = self.getDefaultFrom()
        self.toCurrency.text = self.getDefaultTo()
        self.widgetBaseCurrency.text = self.getWidgetBase()
        self.widgetFirstCurrency.text = self.getWidgetFirst()
        self.widgetSecondCurrency.text = self.getWidgetSecond()
    }

    func pickerViewSelected(selected: String, index: Int) {
        switch self.selectedIndex?.section {
        case 0:
            self.baseCurrency.text = selected
            let values = self.getAllCurrenciesDict()[selected] as? Dictionary<String,Any>
            self.setBaseCurrency(code: selected, name: values!["Name"] as! String, symbol: values!["Symbol"] as! String)
            NotificationCenter.default.post(name: NSNotification.Name("BaseCurrency"), object: nil)
            break
        case 1:
            switch selectedIndex?.row {
            case 0:
                self.fromCurrency.text = selected
                NotificationCenter.default.post(name: NSNotification.Name("FromCurrency"), object: selected)
                break
            case 1:
                self.toCurrency.text = selected
                NotificationCenter.default.post(name: NSNotification.Name("ToCurrency"), object: selected)
                break
            default:
                break
            }
            break
        case 2:
            switch selectedIndex?.row {
            case 0:
                self.widgetBaseCurrency.text = selected
                self.setWidgetBase(value: selected)
                break
            case 1:
                self.widgetFirstCurrency.text = selected
                self.setWidgetFirst(value: selected)
                break
            case 2:
                self.widgetSecondCurrency.text = selected
                self.setWidgetSecond(value: selected)
                break
            default:
                break
            }
            break
         default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.customPickerViewController(array: self.getAllCurrencies())
    }

}
