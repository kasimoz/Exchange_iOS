//
//  TodayViewController.swift
//  latest
//
//  Created by KasimOzdemir on 7.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire
import AlamofireObjectMapper

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var baseIcon: UIImageView!
    @IBOutlet weak var firstIcon: UIImageView!
    @IBOutlet weak var secondIcon: UIImageView!
    @IBOutlet weak var baseLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseLabel.textColor = .white
        self.firstLabel.textColor = .white
        self.secondLabel.textColor = .white
        self.setWidgetView()
    }
    
    func setWidgetView(){
        let allCurrenciesDic = self.getAllCurrenciesDict()
        let valuesBase = allCurrenciesDic[self.getWidgetBase()] as? Dictionary<String,Any>
        self.baseIcon?.image = UIImage.init(named: valuesBase!["Image"] as! String)
        self.baseLabel.text = "\(valuesBase!["Symbol"] as! String)1"
        
        let valuesFirst = allCurrenciesDic[self.getWidgetFirst()] as? Dictionary<String,Any>
        self.firstIcon?.image = UIImage.init(named: valuesFirst!["Image"] as! String)
        
        let valuesSecond = allCurrenciesDic[self.getWidgetSecond()] as? Dictionary<String,Any>
        self.secondIcon?.image = UIImage.init(named: valuesSecond!["Image"] as! String)
        
        self.latestService(symbolFirst: valuesFirst!["Symbol"] as! String, symbolSecond: valuesSecond!["Symbol"] as! String)
    }
    
    func latestService(symbolFirst : String, symbolSecond : String){
        let parameters: [String: AnyObject] = [
            "base": self.getWidgetBase(),
            "symbols": "\(self.getWidgetFirst()),\(self.getWidgetSecond())"
            ] as [String: AnyObject]
        Alamofire.request(AlamofireClient.latest, method: .get, parameters: parameters).validate(statusCode: 200..<201).responseObject { (response: DataResponse<Latest>) in
            DispatchQueue.main.async {
                let latest = response.result.value
                if response.result.isSuccess && latest != nil{
                    self.firstLabel.text = String.init(format: "%@%.3f", symbolFirst, latest?.rates?[self.getWidgetFirst()] ?? 0.0)
                    self.secondLabel.text = String.init(format: "%@%.3f", symbolSecond, latest?.rates?[self.getWidgetSecond()] ?? 0.0)
                }
            }
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
