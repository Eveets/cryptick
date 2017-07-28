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
    var percentLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        quoteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/3))
        quoteLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        quoteLabel.textAlignment = .center
        contentView.addSubview(quoteLabel)
        
        priceLabel = UILabel(frame: CGRect(x: 0, y:frame.size.height/3 , width: frame.size.width, height: frame.size.height/3))
        priceLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        priceLabel.textAlignment = .center
        contentView.addSubview(priceLabel)
        
        percentLabel = UILabel(frame: CGRect(x: 0, y: 2*frame.size.height/3, width: frame.size.width, height: frame.size.height/3))
        percentLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        percentLabel.textAlignment = .center
        contentView.addSubview(percentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
