//
//  ContentView.swift
//  iWeather
//
//  Created by Mohamed Salah on 17/09/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WeatherView()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
