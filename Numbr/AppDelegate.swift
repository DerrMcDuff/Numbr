//
//  AppDelegate.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-21.
//  Copyright © 2017 anonymous. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var split: UISplitViewController?
    
    var allData: GeneralData!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        split = (self.window!.rootViewController as! UISplitViewController)
        let navigationController = split?.viewControllers.first(where: {$0.title=="Master"}) as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = split?.displayModeButtonItem
        
        allData = GeneralData()
        allData.loadData()
        
        if allData.notes.isEmpty {
            allData.notes.append(Note(at:0))
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        allData.saveData()
    }


}

