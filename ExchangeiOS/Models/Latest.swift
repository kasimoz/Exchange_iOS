//
//  Latest.swift
//  ExchangeiOS
//
//  Created by KasimOzdemir on 7.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import ObjectMapper

struct Latest : Mappable {
    var rates : Dictionary<String,Double>?
    var base : String?
    var date : String?

    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        rates <- map["rates"]
        base <- map["base"]
        date <- map["date"]
    }
    
}
