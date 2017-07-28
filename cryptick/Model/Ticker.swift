//
//  Ticker.swift
//  cryptick
//
//  Created by Steeve Monniere on 20-07-2017.
//  Copyright © 2017 Steeve Monniere. All rights reserved.
//

import UIKit

class Ticker: NSObject {
    //Pair Info
    
    var base:String?
    var quote:String?
    
    var active : Bool = false

    //Info
    var price:Double?
    var ask:Double?
    var bid:Double?
    var low:Double?
    var high:Double?
    var volume:Double?
    var openPrice:Double?
    
    
    //Calculated value
    var pairName:String {
        get{return String.localizedStringWithFormat("%@%@", base!, quote!)}
        set{}
    }
    
    
    var percentChange:Double {
        get{
            if(price != nil && openPrice != nil && openPrice != 0.0){
                return price!/openPrice!;
            }
            else
            {
                return 0.00
            }
        }
        set{}
    }
    
    static func ticker (base:String, quote:String) -> Ticker
    {
        let t = Ticker.init()
        t.base = base
        t.quote = quote
        return t
    }
}
