//
//  iWeatherApp.swift
//  iWeather
//
//  Created by Mohamed Salah on 17/09/2023.
//

import SwiftUI

@main
struct iWeatherApp: App {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
                .animation(.easeInOut, value: isDarkModeEnabled)
        }
    }
}
