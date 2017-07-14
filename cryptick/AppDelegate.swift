//
//  AppDelegate.swift
//  cryptick
//
//  Created by Steeve Monniere on 13-07-2017.
//  Copyright © 2017 Steeve Monniere. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        var navigationController:UINavigationController!
        var tabBarController:UITabBarController!
        var viewController1:MainViewController!
        var viewController2:MainViewController!
        var viewController3:MainViewController!
        
        viewController1 = MainViewController()
        viewController1.title = "XBT"
        viewController1.currencySymbol = "XBT"
        viewController1.currencyValue = 2401.54
        viewController1.refCurrencySymbol = "USD"
        viewController2 = MainViewController()
        viewController2.title = "ETH"
        viewController2.currencySymbol = "ETH"
        viewController2.currencyValue = 204.11
        viewController2.refCurrencySymbol = "USD"
        viewController3 = MainViewController()
        viewController3.title = "USD"
        viewController3.currencySymbol = "USD"
        viewController3.refCurrencySymbol = "CAD"
        viewController3.currencyValue = 1.27982

        tabBarController = UITabBarController()
        tabBarController.addChildViewController(viewController1)
        tabBarController.addChildViewController(viewController2)
        tabBarController.addChildViewController(viewController3)
        
        navigationController = UINavigationController(rootViewController: tabBarController)
        self.window?.rootViewController = navigationController
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
