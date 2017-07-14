//
//  MainViewController.swift
//  cryptick
//
//  Created by Steeve Monniere on 13-07-2017.
//  Copyright © 2017 Steeve Monniere. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var currencySymbolLabel:UILabel!
    var currencyValueLabel:UILabel!
    
    var collectionView: UICollectionView!

    
    public var currencySymbol:String = ""{
        didSet {
            if(currencySymbolLabel != nil){
                
                currencySymbolLabel.text = currencySymbol
            }
        }
    }
    
    public var refCurrencySymbol:String = ""{
        didSet {
            if(currencyValueLabel != nil){
                currencyValueLabel.text = String.init(format: "%0.2f (%@)", currencyValue, refCurrencySymbol)
            }
        }
    }
    
    public var currencyValue:Float = 0.0 {
        
        didSet(newCurrencyValue) {
            if(currencyValueLabel != nil){
                currencyValueLabel.text = String.init(format: "%0.2f (%@)", currencyValue, refCurrencySymbol)
            }
        }
        
    }
  
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        
        currencySymbolLabel = UILabel()
        currencySymbolLabel.text = currencySymbol.uppercased()
        currencySymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        currencySymbolLabel.textColor = UIColor.white
        currencySymbolLabel.textAlignment = NSTextAlignment.center
        view.addSubview(currencySymbolLabel)
        
        currencyValueLabel = UILabel()
        currencyValueLabel.text = String.init(format: "%0.2f (USD)", currencyValue)
        currencyValueLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyValueLabel.textColor = UIColor.white
        currencyValueLabel.textAlignment = NSTextAlignment.center
        view.addSubview(currencyValueLabel)
        
        self.makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Update the Currency data
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func makeConstraints(){
        
        let horizontalConstraint = currencySymbolLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = currencySymbolLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:65.0)
        let widthConstraint = currencySymbolLabel.widthAnchor.constraint(equalToConstant: 400)
        let heightConstraint = currencySymbolLabel.heightAnchor.constraint(equalToConstant: 25)
        
        
        let horizontalConstraint1 = currencyValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint1 = currencyValueLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:90.0)
        let widthConstraint1 = currencyValueLabel.widthAnchor.constraint(equalToConstant: 400)
        let heightConstraint1 = currencyValueLabel.heightAnchor.constraint(equalToConstant: 25)
        
        let horizontalConstraint2 = collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint2 = collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant:115.0)
        let widthConstraint2 = collectionView.widthAnchor.constraint(equalTo:view.widthAnchor)
        let heightConstraint2 = collectionView.heightAnchor.constraint(equalTo:view.heightAnchor, constant:-115.0)
        
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint,horizontalConstraint1, verticalConstraint1, widthConstraint1, heightConstraint1,horizontalConstraint2, verticalConstraint2, widthConstraint2, heightConstraint2])
        
        
        
    }
    
    //CollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.orange
        return cell
    }
    
}
