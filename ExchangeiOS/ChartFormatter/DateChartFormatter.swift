//
//  DateChartFormatter.swift
//  ExchangeiOS
//
//  Created by KasimOzdemir on 7.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import Charts

class DateChartFormatter:NSObject,IAxisValueFormatter{

    var dateArray : [String]?
   
    
    init(array : [String]) {
        self.dateArray = array
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value < 0 || Int(value) > (dateArray?.count ?? 0) - 1{
            return ""
        }
        return dateArray![Int(value)].toDate()
    }
}
