//
//  AppDelegate.swift
//  ExampleApp
//
//  Created by hideto.higashi on 2025/03/04.
//

import SwiftUI
import ComposableArchitecture
import AppRootFeature

final class AppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(initialState: AppRootFeature.State()) {
        AppRootFeature()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}
