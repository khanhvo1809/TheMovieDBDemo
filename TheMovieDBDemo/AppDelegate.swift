//
//  AppDelegate.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SimpleNetworkDetection.shared.startMonitor()
        return true
    }
}

