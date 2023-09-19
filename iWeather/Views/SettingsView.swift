//
//  SettingsView.swift
//  iWeather
//
//  Created by Mohamed Salah on 17/09/2023.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $isDarkModeEnabled) {
                    Text("Dark Mode")
                }
                .navigationTitle("Settings")
            }
        }
    }
}
    
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
