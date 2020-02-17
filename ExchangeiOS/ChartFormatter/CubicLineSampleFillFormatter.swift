//
//  CubicLineSampleFillFormatter.swift
//  ExchangeiOS
//
//  Created by KasimOzdemir on 7.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import Charts

class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}
