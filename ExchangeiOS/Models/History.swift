//
//  History.swift
//  ExchangeiOS
//
//  Created by KasimOzdemir on 7.02.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import ObjectMapper

struct History : Mappable {
    var rates : Dictionary<String,Any>?
    var base : String?
    var start_at : String?
    var end_at : String?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        rates <- map["rates"]
        base <- map["base"]
        start_at <- map["start_at"]
        end_at <- map["end_at"]
    }
    
}
