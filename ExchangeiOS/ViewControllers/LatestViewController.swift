//
//  LatestViewController.swift
//  ExchangeiOS
//
//  Created by KasimOzdemir on 7.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class LatestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomPickerViewDelegate {
    var currencies : Dictionary<String,Any>!
    var currenciesArray : [String] = []
    var mainLatest : Latest?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencies = self.getAllCurrenciesDict()
        self.currenciesArray = self.getCurrenciesArray()
        
        NotificationCenter.default.addObserver(self, selector:  #selector(self.reloadTableView), name: NSNotification.Name("ReloadTableView"), object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(self.baseCurrencySettings), name: NSNotification.Name("BaseCurrency"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(Date().millisecondsSince1970.subtractingReportingOverflow(self.getLatestRequestTime()).partialValue > 0 && Date().millisecondsSince1970.subtractingReportingOverflow(self.getLatestRequestTime()).partialValue < (30*60)){
            self.mainLatest = self.getLatest()
            self.tableView.reloadData()
            return
        }
        self.latestService()
    }
    
    @objc func baseCurrencySettings(){
        self.latestService()
    }
    
    @objc func reloadTableView(){
        self.currenciesArray = self.getCurrenciesArray()
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "header")
        headerCell?.frame = CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: 72.0)
        headerView.addSubview(headerCell!)
        let flag = headerCell?.viewWithTag(1) as? UIImageView
        let code = headerCell?.viewWithTag(2) as? UILabel
        let name = headerCell?.viewWithTag(3) as? UILabel
        let money = headerCell?.viewWithTag(4) as? UILabel
        let values = self.currencies?[self.getBaseCurrency()[0]] as? Dictionary<String,Any>
        flag?.image = UIImage.init(named: values!["Image"] as! String)
        code?.text = self.getBaseCurrency()[0]
        name?.text = self.getBaseCurrency()[1]
        money?.text = self.getBaseCurrency()[2] + "1"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainLatest != nil ? self.currenciesArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let flag = cell?.viewWithTag(1) as? UIImageView
        let code = cell?.viewWithTag(2) as? UILabel
        let name = cell?.viewWithTag(3) as? UILabel
        let money = cell?.viewWithTag(4) as? UILabel
        let values = self.currencies?[self.currenciesArray[indexPath.row]] as? Dictionary<String,Any>
        flag?.image = UIImage.init(named: values!["Image"] as! String)
        code?.text = self.currenciesArray[indexPath.row]
        name?.text = values!["Name"] as? String
        money?.text = (values!["Symbol"] as! String) + String.init(format: "%.3f", self.mainLatest?.rates?[self.currenciesArray[indexPath.row]] ?? 1.0)
        return cell!
    }
    
    func latestService(){
        let parameters: [String: AnyObject] = [
            "base": self.getBaseCurrency()[0]
            ] as [String: AnyObject]
        Alamofire.request(AlamofireClient.latest, method: .get, parameters: parameters).validate(statusCode: 200..<201).responseObject { (response: DataResponse<Latest>) in
            DispatchQueue.main.async {
                let latest = response.result.value
                if response.result.isSuccess && latest != nil{
                    self.setLatestRequestTime(Date().millisecondsSince1970)
                    self.mainLatest = latest
                    self.setLatest(latest!)
                    self.tableView.reloadData()
                }
            }
        }
    }

    @IBAction func baseCurrency(_ sender: Any) {
        self.customPickerViewController(array: self.getAllCurrencies())
    }
    
    func pickerViewSelected(selected: String, index: Int) {
        let values = self.currencies?[selected] as? Dictionary<String,Any>
        self.setBaseCurrency(code: selected, name: values!["Name"] as! String, symbol: values!["Symbol"] as! String)
        self.tableView.reloadData()
        self.latestService()
    }
    
    @IBAction func addCurrency(_ sender: Any) {
        self.performSegue(withIdentifier: "editCurrencyList", sender: nil)
    }
}

