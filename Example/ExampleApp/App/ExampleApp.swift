//
//  ExampleAppApp.swift
//  ExampleApp
//
//  Created by hideto.higashi on 2025/03/04.
//

import SwiftUI
import AppRootFeature

@main
struct ExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            AppRootView(store: self.appDelegate.store)
        }
    }
}
