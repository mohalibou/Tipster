//
//  ContentView.swift
//  Tipster
//
//  Created by Mohamed Ali Boutaleb on 5/7/22.
//

import SwiftUI
import MessageUI
import Combine

struct HomeView: View {
    
    @AppStorage("currencySymbol") var currencySymbol: String = "$"
    @AppStorage("appColor") var appColor: String = "appRed"
    @AppStorage("vibrations") var vibrations: Bool = true
    @FocusState private var focusedTextField: Bool
    @State private var splittingBill = false
    @State private var billAmount = ""
    @State private var tipPercentage = ""
    @State private var tipAmount = 0.00
    @State private var totalWithTip = 0.00
    
    let vibration = UINotificationFeedbackGenerator()
    let vibrationImpact = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Bill Amount").offset(x:18, y:8)
                            BillTextField(billAmount: $billAmount)
                                .focused($focusedTextField)
                        }
                        .padding(.top, 40)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Tip %").offset(x:18, y:8)
                                HStack {
                                    TipTextField(tipPercentage: $tipPercentage)
                                        .focused($focusedTextField)
                                    if Int(tipPercentage) != nil {
                                        if Int(tipPercentage)! >= 0 && Int(tipPercentage)! < 5 {
                                            Text("😡")
                                                .font(.system(size: 40))
                                                .padding(.trailing, 5)
                                                .padding(.leading, 15)
                                        } else if Int(tipPercentage)! >= 5 && Int(tipPercentage)! < 15 {
                                            Text("😐")
                                                .font(.system(size: 40))
                                                .padding(.trailing, 5)
                                                .padding(.leading, 15)
                                        } else if Int(tipPercentage)! >= 15 && Int(tipPercentage)! < 30 {
                                            Text("😌")
                                                .font(.system(size: 40))
                                                .padding(.trailing, 5)
                                                .padding(.leading, 15)
                                        } else if Int(tipPercentage)! >= 30 && Int(tipPercentage)! < 100 {
                                            Text("🤑")
                                                .font(.system(size: 40))
                                                .padding(.trailing, 5)
                                                .padding(.leading, 15)
                                        } else {
                                            Text("🤯")
                                                .font(.system(size: 40))
                                                .padding(.trailing, 5)
                                                .padding(.leading, 15)
                                        }
                                        
                                    } else {
                                        Text("🤔")
                                            .font(.system(size: 40))
                                            .padding(.trailing, 5)
                                            .padding(.leading, 15)
                                    }
                                }
                            }
                        }
                    }
                    VStack {
                        Text("\(currencySymbol)\(String(format: "%.2f", tipAmount))")
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(Color(appColor))
                        Text("Tip Amount").font(.callout)
                    }
                    .padding()
                    VStack{
                        Text("\(currencySymbol)\(String(format: "%.2f", totalWithTip))")
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(Color(appColor))
                        Text("Total With Tip").font(.callout)
                    }
                    .padding()
                    Spacer()
                    Button("Calculate Tip") {
                        if Double(billAmount) != nil && Double(tipPercentage) != nil {
                            if vibrations { vibration.notificationOccurred(.success) }
                            tipAmount = Double(billAmount)! * (Double(tipPercentage)! * 0.01)
                            totalWithTip = Double(billAmount)! + tipAmount
                            focusedTextField = false
                        }
                    }
                    .frame(width: 300, height: 70)
                    .font(.system(size: 30, weight: .bold))
                    .background(Color(appColor))
                    .foregroundColor(Color(UIColor.systemBackground))
                    .cornerRadius(100)
                    HStack {
                        Button("Split") {
                            if tipAmount != 0 && totalWithTip != 0 {
                                if vibrations { vibrationImpact.impactOccurred() }
                                splittingBill.toggle()
                            }
                            
                        }
                        .buttonStyle(.bordered)
                        .tint(tipAmount != 0 && totalWithTip != 0 ? Color(appColor) : Color.gray)
                        .buttonBorderShape(.capsule)
                        .padding()
                        Button("Reset") {
                            if tipAmount != 0 && totalWithTip != 0 {
                                if vibrations { vibrationImpact.impactOccurred() }
                                billAmount = ""
                                tipPercentage = ""
                                tipAmount = 0.00
                                totalWithTip = 0.00
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(tipAmount != 0 && totalWithTip != 0 ? Color(appColor) : Color.gray)
                        .buttonBorderShape(.capsule)
                        .padding()
                    }
                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("Tipster")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $splittingBill) {
            SplittingBillView(splittingBill: $splittingBill,
                              billAmount: $billAmount,
                              tipPercentage: $tipPercentage,
                              tipAmount: $tipAmount,
                              totalWithTip: $totalWithTip)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}

struct BillTextField: View {
    
    @AppStorage("currencySymbol") var currencySymbol: String = "$"
    @AppStorage("appColor") var appColor: String = "appRed"
    @Binding var billAmount: String
    
    var body: some View {
        HStack {
            Text(currencySymbol)
                .frame(width: 30, alignment: .leading)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color(appColor))
                .offset(x: 15)
            
            TextField("0", text: $billAmount)
                .font(.system(size: 30, weight: .bold))
                .keyboardType(.decimalPad)
                .onChange(of: billAmount) { input in
                    billAmount = billVerification(input)
                }
        }
        .frame(width: 250, height: 50)
        .background(Color(UIColor.quaternaryLabel))
        .cornerRadius(100)
    }
    
    func billVerification(_ input: String) -> String {
        var output = input.filter { "0123456789.".contains($0) }
        if output.filter({ $0 == "." }).count > 1 { output = String(input.dropLast()) }
        if output.contains(".") {
            if output.components(separatedBy: ".")[1].count > 2 { output = String(input.dropLast()) }
        }
        
        return output
    }
    
}

struct TipTextField: View {
    
    @AppStorage("appColor") var appColor: String = "appRed"
    @Binding var tipPercentage: String
    
    var body: some View {
        HStack {
            TextField("0", text: $tipPercentage)
                .font(.system(size: 30, weight: .bold))
                .multilineTextAlignment(.trailing)
                .offset(x: -8)
                .keyboardType(.numberPad)
                .onChange(of: tipPercentage) { input in
                    tipPercentage = tipVerification(input)
                }
            Text("%")
                .frame(width: 30, alignment: .leading)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color(appColor))
                .offset(x: -15)
        }
        .frame(width: 125, height: 50)
        .background(Color(UIColor.quaternaryLabel))
        .cornerRadius(100)
    }
    
    func tipVerification(_ input: String) -> String {
        var output = input.filter { "0123456789".contains($0) }
        if input.count >= 3 { output = "100" }
        return output
    }
    
}

struct SplittingBillView: View {
    
    @AppStorage("currencySymbol") var currencySymbol: String = "$"
    @AppStorage("appColor") var appColor: String = "appRed"
    @AppStorage("vibrations") var vibrations: Bool = true
    
    @Binding var splittingBill: Bool
    @Binding var billAmount: String
    @Binding var tipPercentage: String
    @Binding var tipAmount: Double
    @Binding var totalWithTip: Double
    @State private var amountOfPeople = 2
    @State private var isShowingMessages = false
    
    let vibrationImpact = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationView {
            VStack {
                
                VStack {
                    Text("\(currencySymbol)\(String(format: "%.2f", tipAmount))")
                        .font(.system(size: 45, weight: .bold))
                        .foregroundColor(Color(appColor))
                    Text("Tip Amount").font(.callout)
                }
                .padding()
                
                VStack {
                    Text("\(currencySymbol)\(String(format: "%.2f", totalWithTip))")
                        .font(.system(size: 45, weight: .bold))
                        .foregroundColor(Color(appColor))
                    Text("Total With Tip").font(.callout)
                }
                .padding()
                
                VStack {
                    Text("\(currencySymbol)\(String(format: "%.2f", totalWithTip / Double(amountOfPeople)))")
                        .font(.system(size: 45, weight: .bold))
                        .foregroundColor(Color(appColor))
                    Text("Amount each person pays (including tip)").font(.callout)
                }
                .padding()
                
                VStack {
                    HStack {
                        Stepper("Amount of People", value: $amountOfPeople, in: 2...10).labelsHidden()
                        Text("\(amountOfPeople)")
                            .frame(width: 100, height: 35)
                            .background(Color(UIColor.quaternaryLabel))
                            .cornerRadius(100)
                    }
                    Text("Amount of People")
                }
                .padding()
                
                Button("Request") { if vibrations { vibrationImpact.impactOccurred() }; isShowingMessages = true }
                    .buttonStyle(.bordered)
                    .tint(Color(appColor))
                    .buttonBorderShape(.capsule)
                    .padding()
                
            }
            .navigationTitle("Splitting the Bill")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {splittingBill.toggle()}
                }
            }
        }
        .accentColor(Color(appColor))
        .sheet(isPresented: $isShowingMessages) {
            MessageComposeView(recipients: [""], body: "Your portion of the bill: \(currencySymbol)\(String(format: "%.2f", totalWithTip / Double(amountOfPeople)))") { messageSent in
                print("MessageComposeView with message sent? \(messageSent)")
            }
        }
    }
}
