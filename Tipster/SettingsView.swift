//
//  SettingsView.swift
//  Tipster
//
//  Created by Mohamed Ali Boutaleb on 5/7/22.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("appColor") var appColor: String = "appRed"
    @AppStorage("currencySymbol") var currencySymbol: String = "$"
    @AppStorage("vibrations") var vibrations: Bool = true
    @State private var changingColor = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Form {
                        Section(header: Text("App Settings"), footer: Text("Version: 1.02")) {
                            NavigationLink(destination: SettingsColorView()) {
                                Text("Change Accent Color").foregroundColor(Color(appColor))
                            }
                            NavigationLink(destination: SettingsCurrencyView()) {
                                Text("Change Currency Symbol")
                            }
                            Toggle("Vibrations", isOn: $vibrations)
                                .toggleStyle(SwitchToggleStyle(tint: Color(appColor)))
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}

struct SettingsColorView: View {
    
    @AppStorage("appColor") var appColor: String = "appRed"
    @AppStorage("vibrations") var vibrations: Bool = true
    let vibrationImpact = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                ColorSelectionView(color: "appRed")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; appColor = "appRed" }
                ColorSelectionView(color: "appGreen")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; appColor = "appGreen" }
                ColorSelectionView(color: "appBlue")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; appColor = "appBlue" }
                ColorSelectionView(color: "appPurple")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; appColor = "appPurple" }
            }
            .padding(20)
            Spacer()
        }
        .navigationTitle("Change Accent Color")
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(Color(appColor))
    }
}

struct ColorSelectionView: View {
    
    @AppStorage("appColor") var appColor: String = "appRed"
    var color: String
    
    var body: some View {
        ZStack {
            if (appColor == color) {
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 70, height: 70)
            } else {
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 70, height: 70)
            }
            
            Circle()
                .foregroundColor(Color(color))
                .frame(width: 60, height: 60)
        }
    }
}

struct SettingsCurrencyView: View {
    
    @AppStorage("appColor") var appColor: String = "appRed"
    @AppStorage("currencySymbol") var currencySymbol: String = "$"
    @AppStorage("vibrations") var vibrations: Bool = true
    let vibrationImpact = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                CurrencySelectionView(symbol: "$")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; currencySymbol = "$" }
                CurrencySelectionView(symbol: "€")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; currencySymbol = "€" }
                CurrencySelectionView(symbol: "£")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; currencySymbol = "£" }
                CurrencySelectionView(symbol: "₽")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; currencySymbol = "₽" }
                CurrencySelectionView(symbol: "₺")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; currencySymbol = "₺" }
                CurrencySelectionView(symbol: "₹")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; currencySymbol = "₹" }
                CurrencySelectionView(symbol: "¥")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; currencySymbol = "¥" }
                CurrencySelectionView(symbol: "₩")
                    .onTapGesture { if vibrations { vibrationImpact.impactOccurred() }; currencySymbol = "₩" }
            }
            .padding(20)
            Spacer()
        }
        .navigationTitle("Change Currency Symbol")
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(Color(appColor))
    }
}

struct CurrencySelectionView: View {
    
    @AppStorage("appColor") var appColor: String = "appRed"
    @AppStorage("currencySymbol") var currencySymbol: String = "$"
    var symbol: String
    
    var body: some View {
        ZStack {
            if (currencySymbol == symbol) {
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 70, height: 70)
            } else {
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 70, height: 70)
            }
            Circle()
                .foregroundColor(Color(UIColor.quaternaryLabel))
                .frame(width: 60, height: 60)
            Text(symbol)
                .font(.system(size: 35))
        }
    }
}
