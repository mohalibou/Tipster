//
//  AppTabView.swift
//  Tipster
//
//  Created by Mohamed Ali Boutaleb on 5/7/22.
//

import SwiftUI

struct AppTabView: View {
    
    @AppStorage("appColor") var appColor: String = "appRed"
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .accentColor(Color(appColor))
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
            .preferredColorScheme(.dark)
    }
}
