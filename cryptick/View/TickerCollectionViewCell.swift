//
//  TickerCollectionViewCell.swift
//  cryptick
//
//  Created by Steeve Monniere on 22-07-2017.
//  Copyright © 2017 Steeve Monniere. All rights reserved.
//

import UIKit

class TickerCollectionViewCell: UICollectionViewCell {
    
    var quoteLabel: UILabel!
    var priceLabel: UILabel!
    var lowLabel: UILabel!
    var highLabel: UILabel!
    var percentLabel: UILabel!
    var trendLabel: UILabel!
    
    var ticker:Ticker?
    
    //****
    private var hLabel: UILabel!
    private var pLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //First Column
        quoteLabel = UILabel(frame: CGRect(x: 5, y: frame.size.height/2-18, width: frame.size.width/3-20, height: frame.size.height/2))
        quoteLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        quoteLabel.textAlignment = .left
        contentView.addSubview(quoteLabel)
       
        
        //2nd column
        hLabel = UILabel(frame: CGRect(x:frame.size.width/3+10 , y:5, width: frame.size.width/3-20, height:14.0))
        hLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        hLabel.textAlignment = .center
        hLabel.text = "24h"
        contentView.addSubview(hLabel)
        
        lowLabel = UILabel(frame: CGRect(x: frame.size.width/3+10, y:24 , width: frame.size.width/3-20, height: 14))
        lowLabel.font = UIFont.systemFont(ofSize:12.0)
        lowLabel.textAlignment = .center
        contentView.addSubview(lowLabel)
        
        highLabel = UILabel(frame: CGRect(x: frame.size.width/3+10, y:24+16 , width: frame.size.width/3-20, height: 14))
        highLabel.font = UIFont.systemFont(ofSize: 12.0)
        highLabel.textAlignment = .center
        contentView.addSubview(highLabel)
        
        percentLabel = UILabel(frame: CGRect(x: frame.size.width/3+10, y: 24+2*(16), width: frame.size.width/3-20, height: 14))
        percentLabel.font = UIFont.systemFont(ofSize: 12.0)
        percentLabel.textAlignment = .center
        contentView.addSubview(percentLabel)
        
        
        
        //3rd Column
        pLabel = UILabel(frame: CGRect(x:2*(frame.size.width/3)+10 , y:frame.size.height/2-18, width: frame.size.width/3-20, height:14.0))
        pLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        pLabel.textAlignment = .center
        pLabel.text = "Last"
        contentView.addSubview(pLabel)
        
        priceLabel = UILabel(frame: CGRect(x: 2*frame.size.width/3+10, y:frame.size.height/2 , width: frame.size.width/3-20, height:14.0))
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.textAlignment = .center
        contentView.addSubview(priceLabel)
        
        trendLabel = UILabel(frame: CGRect(x: 2*frame.size.width/3+10, y:frame.size.height/2+16 , width: frame.size.width/3-20, height:12.0))
        trendLabel.font = UIFont.systemFont(ofSize: 12)
        trendLabel.textAlignment = .center
        contentView.addSubview(trendLabel)
        
        
    }
    
    func updateTicker(ticker:Ticker)
    {
        self.ticker = ticker
        
        let precision:String = getCurrencyPrecision(currency: ticker.quote!)
        let trend:Double = (ticker.price!/ticker.vwap!-1)*100
        
        self.quoteLabel.text = String.localizedStringWithFormat("%@/%@", ticker.base!.uppercased(), ticker.quote!.uppercased())
        self.priceLabel.text = String.localizedStringWithFormat(precision, ticker.price!)
        self.lowLabel.text = String.localizedStringWithFormat("Low: "+precision, ticker.low!)
        self.highLabel.text = String.localizedStringWithFormat("High: "+precision, ticker.high!)
        self.percentLabel.text = String.localizedStringWithFormat("Avg : "+precision, ticker.vwap!)
        self.trendLabel.text = String.localizedStringWithFormat("(%0.2f%%)", trend)
        if(trend < 0)
        {
            self.trendLabel.textColor = UIColor.red
        }
        else
        {
            self.trendLabel.textColor = UIColor(red:35.0/255, green:160.0/255, blue:35.0/255, alpha: 1.0)
        }
        if(!ticker.unchanged)
        {
            self.animate(up: ticker.up)
        }
        
    }
    
    func animate(up:Bool)
    {
        if(up){
            self.backgroundColor = UIColor(red: 35/255, green: 160/255, blue: 35/255, alpha: 0.5)
        }
        else
        {
            self.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options:[UIViewAnimationOptions.curveEaseOut], animations: {
            if(up){
              self.backgroundColor = UIColor(red: 35/255, green: 160/255, blue: 35/255, alpha: 0.0)
            }
            else
            {
                self.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.0)
            }
        }, completion:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
