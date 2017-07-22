//
//  Ticker.swift
//  cryptick
//
//  Created by Steeve Monniere on 20-07-2017.
//  Copyright © 2017 Steeve Monniere. All rights reserved.
//

import UIKit

class Ticker: NSObject {
    var originCurrency: String?
    var destinationCurrency: String?
    var trade_id:Int64?
    var price:Int64?
    var size:Int64?
    var bid:Int64?
    var ask:Int64?
    var volume:Int64?
    var time:Date?
    
    static func ticker (originCurrency :String,  destinationCurrency: String) -> Ticker
    {
        let t = Ticker.init()
        t.originCurrency = originCurrency
        t.destinationCurrency = destinationCurrency
        return t
    }
}
