//
//  CustomPickerView.swift
//  ExchangeiOS
//
//  Created by KasimOzdemir on 6.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//
import Foundation
import UIKit

class CustomPickerView: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    var delegate: CustomPickerViewDelegate?
    var array : [String] = ["TRY"]
    var result = ""
    var index = 0
    let customPickerViewHeight : CGFloat = 294.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottom.constant = -self.itemHeight
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animateView()
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomPickerView.close))
        
        view.addGestureRecognizer(tap)
        self.result = self.array[index]
        
        
    }
    
    @objc func close() {
        self.bottom.constant = -self.itemHeight
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.view.layoutIfNeeded()
        }, completion: {(finished : Bool) in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func kapat(_ sender: Any) {
        self.bottom.constant = -self.itemHeight
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.view.layoutIfNeeded()
        }, completion: {(finished : Bool) in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func animateView() {
        self.bottom.constant = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel : UILabel
        
        
        if let view = view {
            pickerLabel = view as! UILabel
        }
        else {
            pickerLabel = UILabel(frame: CGRect(x: 8, y: 0, width: pickerView.frame.width - 16.0, height: 50))
        }
        pickerLabel.text =  self.array[row]
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        pickerLabel.lineBreakMode = .byWordWrapping
        pickerLabel.numberOfLines = 0
        pickerLabel.textColor = .label
        return pickerLabel
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.result = self.array[row]
        self.index = row
    }
    
    @IBAction func update(_ sender: Any) {
        self.close()
        self.delegate?.pickerViewSelected(selected: self.result, index : self.index)
    }
    
    var itemHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return self.customPickerViewHeight + (window?.safeAreaInsets.bottom ?? 0.0)
    }
}



protocol CustomPickerViewDelegate: class {
    func pickerViewSelected(selected: String, index : Int)
}
