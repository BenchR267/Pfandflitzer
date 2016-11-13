//
//  AppDelegate.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        appearance()
        return true
    }

    func appearance() {
        
        let green = UIColor(red: 47.0/255, green: 172.0/255, blue: 102.0/255, alpha: 1)
        
        let textAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().barTintColor = green
        UINavigationBar.appearance().isTranslucent = false

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        
        UIButton.appearance().tintColor = green
    }
    
}

