//
//  MainViewController.swift
//  cryptick
//
//  Created by Steeve Monniere on 13-07-2017.
//  Copyright © 2017 Steeve Monniere. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var baseSymbolLabel:UILabel!
    var priceLabel:UILabel!
    var activityView:UIActivityIndicatorView!
    
    
    
    var collectionView: UICollectionView!

    
    var ticker :Ticker? = nil
    
    public var base:String = ""{
        didSet {
            if(base != "" && quote != ""){
                self.updateData()
            }
        }
    }
    
    public var quote:String = ""{
        didSet {
            if(base != "" && quote != ""){
                self.updateData()
            }
        }
    }
    
  
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        activityView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activityView.hidesWhenStopped = true
        activityView.frame = CGRect(x: self.view.frame.width/2-50, y: self.view.frame.height/2-50, width: 100, height: 100)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = true
        collectionView.register(TickerCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        
        baseSymbolLabel = UILabel()
        baseSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        baseSymbolLabel.textColor = UIColor.white
        baseSymbolLabel.textAlignment = NSTextAlignment.center
        view.addSubview(baseSymbolLabel)
        
        priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textColor = UIColor.white
        priceLabel.textAlignment = NSTextAlignment.center
        view.addSubview(priceLabel)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.updateData(notification:)), name: Notification.Name("com.chinchillasoft.tickerDataupdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.startLoading(notification:)), name: Notification.Name("com.chinchillasoft.startLoading"), object: nil)
        
        self.view .addSubview(activityView)
    
        self.makeConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Update the Currency data
        self.updateData()
        self.navigationController?.navigationBar.topItem?.title = self.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("com.chinchillasoft.startLoading"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("com.chinchillasoft.tickerDataupdated"), object: nil)
    }
    
    
    func startLoading(notification: Notification)
    {
        activityView.startAnimating()
    }
    
    func updateData(notification: Notification)
    {
        self.updateData()
        activityView.stopAnimating()
    }
    public func updateData()
    {
        //Determine the main ticker for this page and update the header
        ticker = TickerManager.sharedInstance.tickerWith(base: base, quote: quote)
        if(ticker != nil)
        {
            baseSymbolLabel.text = self.base.substring(from: 1).uppercased()
            priceLabel.text = String.init(format: "%0.2f (%@)", (ticker?.price ?? 0.00)!, self.quote.substring(from: 1).uppercased())
        }
        //Update the collectionView with all the pairs
        if(TickerManager.sharedInstance.tickerReady)
        {
            collectionView.reloadData()
        }
        
        
        
    }

    func makeConstraints(){
        
        let horizontalConstraint = baseSymbolLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = baseSymbolLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:65.0)
        let widthConstraint = baseSymbolLabel.widthAnchor.constraint(equalToConstant: 400)
        let heightConstraint = baseSymbolLabel.heightAnchor.constraint(equalToConstant: 25)
        
        
        let horizontalConstraint1 = priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint1 = priceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:90.0)
        let widthConstraint1 = priceLabel.widthAnchor.constraint(equalToConstant: 400)
        let heightConstraint1 = priceLabel.heightAnchor.constraint(equalToConstant: 25)
        
        let horizontalConstraint2 = collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint2 = collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant:115.0)
        let widthConstraint2 = collectionView.widthAnchor.constraint(equalTo:view.widthAnchor)
        let heightConstraint2 = collectionView.heightAnchor.constraint(equalTo:view.heightAnchor, constant:-115.0)
        
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint,horizontalConstraint1, verticalConstraint1, widthConstraint1, heightConstraint1,horizontalConstraint2, verticalConstraint2, widthConstraint2, heightConstraint2])
        
        
        
    }
    
    //CollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TickerManager.sharedInstance.activeTicker(base: self.base).count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let ticker = TickerManager.sharedInstance.activeTicker(base: self.base)[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.orange
        let tCell = cell as! TickerCollectionViewCell
        tCell.quoteLabel.text = ticker.quote?.substring(from: 1)
        tCell.priceLabel.text = String.localizedStringWithFormat("%0.2f", ticker.price!)
        tCell.percentLabel.text = String.localizedStringWithFormat("%0.2f%%", 100 * (ticker.percentChange - 1))
        
        return cell
    }
    
}
