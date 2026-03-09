//
//  Food_Recipe_App_iOSApp.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/3/26.
//
import SwiftUI
import FirebaseCore

@main
struct Food_Recipe_App_iOSApp: App {

    init() {
        FirebaseApp.configure()
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.systemGreen
    }

    var body: some Scene {
        WindowGroup {
            AppRouter()
        }
    }
}
