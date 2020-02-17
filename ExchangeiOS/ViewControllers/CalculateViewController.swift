//
//  CalculateViewController.swift
//  ExchangeiOS
//
//  Created by KasimOzdemir on 7.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import AlamofireObjectMapper

class CalculateViewController: UIViewController, CustomPickerViewDelegate{
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    var selectedButton : UIButton?
    var mainHistory : History?
    var weekArray : [String] = []
    var monthArray : [String] = []
    var yearArray : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewTouch()
        self.setButtons(selected: self.getDefaultFrom(), button: self.fromButton)
        self.setButtons(selected: self.getDefaultTo(), button: self.toButton)
        
        lineChart.setViewPortOffsets(left: 0, top: 20, right: 0, bottom: 0)
        
        lineChart.dragEnabled = false
        lineChart.setScaleEnabled(true)
        lineChart.pinchZoomEnabled = false
        lineChart.maxHighlightDistance = 300
        
        lineChart.xAxis.enabled = true
        
        let xAxis = lineChart.xAxis
        xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size:12)!
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = .label
        xAxis.labelPosition = .top
        xAxis.axisLineColor = .label
       
        
        let yAxis = lineChart.leftAxis
        yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size:12)!
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .label
        yAxis.labelPosition = .insideChart
        yAxis.axisLineColor = .label
        
        lineChart.rightAxis.enabled = false
        lineChart.legend.enabled = false

        lineChart.animate(xAxisDuration: 2, yAxisDuration: 2)
        
        if self.getLastChart().end_at == nil {
            self.historyService()
        }else if self.getLastChart().end_at != Date().toString(){
            self.historyService()
        }else{
            self.mainHistory = self.getLastChart()
            self.reloadChart()
        }
        
        NotificationCenter.default.addObserver(self, selector:  #selector(self.setFromCurrency(_:)), name: NSNotification.Name("FromCurrency"), object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(self.setToCurrency(_:)), name: NSNotification.Name("ToCurrency"), object: nil)
    }
    
    
    @objc func setFromCurrency(_ notification : NSNotification){
        let selected = (notification.object as? String)!
        self.setButtons(selected: selected, button: self.fromButton)
    }
    
    @objc func setToCurrency(_ notification : NSNotification){
        let selected = (notification.object as? String)!
        self.setButtons(selected: selected, button: self.toButton)
    }
    
    func reloadChart(){
        let dateArray = Array((self.mainHistory?.rates?.keys)!).sorted(by: <)
        let arraySliceWeek = dateArray.suffix(7)
        let arraySliceMonth = dateArray.suffix(30)
        self.weekArray = Array(arraySliceWeek)
        self.monthArray = Array(arraySliceMonth)
        self.yearArray = dateArray
        self.setDataCount(self.weekArray)
        self.segmentedControl.selectedSegmentIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
         
    @IBAction func amountDidBegin(_ sender: UITextField) {
        self.amountTextField.text = ""
        self.resultTextField.text = ""
    }
    
        
    @IBAction func btnbutton(_ sender: Any) {
        self.view.endEditing(true)
        if !(self.amountTextField.text?.isEmpty ?? true) {
            self.calculationService()
        }
    }
    
    func calculationService(){
        let parameters: [String: AnyObject] = [
            "base": self.getDefaultFrom(),
            "symbols": self.getDefaultTo()
            ] as [String: AnyObject]
        Alamofire.request(AlamofireClient.latest, method: .get, parameters: parameters).validate(statusCode: 200..<201).responseObject { (response: DataResponse<Latest>) in
            DispatchQueue.main.async {
                let latest = response.result.value
                if response.result.isSuccess && latest != nil{
                    if let amount = Double(self.amountTextField.text!) {
                        let result = amount * (latest?.rates?[self.getDefaultTo()] ?? 0.0)
                        self.resultTextField.text = String.init(format: "%.3f", result)
                    }
                }
            }
        }
    }
    
    func historyService(){
        let parameters: [String: AnyObject] = [
            "start_at": Date().addingDay(-365).toString(),
            "end_at": Date().toString(),
            "base": self.getDefaultFrom(),
            "symbols": self.getDefaultTo()
            ] as [String: AnyObject]
        Alamofire.request(AlamofireClient.history, method: .get, parameters: parameters).validate(statusCode: 200..<201).responseObject { (response: DataResponse<History>) in
            DispatchQueue.main.async {
                let history = response.result.value
                if response.result.isSuccess && history != nil{
                    self.saveLastChart(history!)
                    self.mainHistory = history
                    self.reloadChart()
                }
            }
        }
    }
    
    func setDataCount(_ array: [String]) {
        let xAxis = lineChart.xAxis
        xAxis.spaceMin = Double(array.count / 7)
        xAxis.spaceMax = Double(array.count / 7)
        xAxis.valueFormatter = DateChartFormatter(array: array)
        let yVals1 = (0..<array.count).map { (i) -> ChartDataEntry in
            let dict = self.mainHistory?.rates?[array[i]] as? Dictionary<String,Double>
            let value = dict?[self.getDefaultTo()]
            return ChartDataEntry(x: Double(i), y: value ?? 0.0)
        }

        let set1 = LineChartDataSet(entries: yVals1, label: self.getDefaultTo())
        set1.mode = .cubicBezier
        set1.drawFilledEnabled = true
        set1.drawCirclesEnabled = false
        set1.lineWidth = 1.8
        set1.circleRadius = 4
        set1.setCircleColor(.label)
        set1.highlightColor = UIColor.clear
        set1.fillColor = UIColor.init("D33B38")
        set1.fillAlpha = 0
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.fillFormatter = CubicLineSampleFillFormatter()
        set1.colors = [UIColor.init("D33B38")]
        let data = LineChartData(dataSet: set1)

        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 9)!)
        data.setValueTextColor(.label)
        data.setDrawValues(true)
        
        self.lineChart.data = data
    }
      
    @IBAction func chartPeriod(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.setDataCount(self.weekArray)
            break
        case 1:
            self.setDataCount(self.monthArray)
            break
        case 2:
            self.setDataCount(self.yearArray)
            break
        default:
            break
        }
    }
    @IBAction func selectFrom(_ sender: Any) {
        self.selectedButton = self.fromButton
        self.customPickerViewController(array: self.getAllCurrencies())
    }
    
    @IBAction func selectTo(_ sender: Any) {
        self.selectedButton = self.toButton
        self.customPickerViewController(array: self.getAllCurrencies())
    }
    
    func pickerViewSelected(selected: String, index: Int) {
        self.setButtons(selected: selected, button: self.selectedButton!)
    }
    
    func setButtons(selected : String , button : UIButton){
        let values = self.getAllCurrenciesDict()[selected] as? Dictionary<String,Any>
        if button == fromButton {
            if selected != self.getDefaultFrom() {
                self.setDefaultFrom(from: selected)
                self.historyService()
            }
            self.fromButton.setImage(UIImage.init(named: values!["Image"] as! String), for: .normal)
            self.fromLabel.text = "\(selected) - \(values!["Symbol"] as! String)"
            self.setDefaultFrom(from: selected)
           
        }else if button == toButton{
            if selected != self.getDefaultTo(){
                self.setDefaultTo(to: selected)
                self.historyService()
            }
            self.toButton.setImage(UIImage.init(named: values!["Image"] as! String), for: .normal)
            self.toLabel.text = "\(selected) - \(values!["Symbol"] as! String)"
            self.setDefaultTo(to: selected)
        }
        self.amountTextField.text = ""
        self.resultTextField.text = ""
    }
}


    

