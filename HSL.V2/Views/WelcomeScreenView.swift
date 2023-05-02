//
//  WelcomeScreenView.swift
//  HSL.V2
//
//  Created by Yana Krylova on 17.4.2023.
//

import SwiftUI
import UserNotifications

struct WelcomeScreenView: View  {
    @StateObject private var model = WelcomeScreenModel()
    // User input variables
    @State private var name = ""
    private let roles: [String] = [
        "Passenger",
        "Driver"
    ]
    @State private var notifications = false
    @State private var selectedRole = "Passenger"
    @State private var termsAccepted = false
    @State private var isNotificationEnabled = false
    @State private var enableLocation = false
    @AppStorage("welcomeScreenShown")
    var welcomeScreenShown: Bool = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                Text(NSLocalizedString("WelcomeScreenString_lableTitle", comment: ""))
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 100)
                    .foregroundColor(.white)
                
                // Sign in as dropdown
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("SigninAs", comment: ""))
                        .font(.headline)
                    Picker(selection: $selectedRole, label: Text("")) {
                        Text(NSLocalizedString("Passenger", comment: "")).tag("Passenger")
                        Text(NSLocalizedString("Driver", comment: "")).tag("Driver")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.top, 30)
                .padding(.horizontal, 50)
                .foregroundColor(.white)
                
                
                // Location toggle
                VStack(alignment: .leading) {
                    Toggle(isOn: $enableLocation) {
                        Text(NSLocalizedString("AllowLocation", comment: ""))
                            .font(.headline)
                    }
                }
                .onAppear {
                    model.requestLocationAuthorization()
                    enableLocation = true
                }
                .padding(.top, 30)
                .padding(.horizontal, 50)
                .foregroundColor(.white)
                
                // Notification toggle
                VStack {
                    Toggle(isOn: $isNotificationEnabled) {
                        Text(NSLocalizedString("AllowNotifications", comment: ""))
                    }
                }
                .onAppear {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        if granted {
                            self.isNotificationEnabled = true
                        } else {
                            self.isNotificationEnabled = false
                        }
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal, 50)
                .foregroundColor(.white)
                
                
                // Terms and conditions checkbox
                VStack(alignment: .leading) {
                    Toggle(isOn: $termsAccepted) {
                        Text(NSLocalizedString("TermsandConditions", comment: ""))
                            .font(.headline)
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal, 50)
                .foregroundColor(.white)
                
                // Continue button
                NavigationLink(
//                    destination: Group {
//                        if selectedRole == "Passenger" {
//                            MainView()
//                        } else {
//                            MainView()
//                        }
//                    }
                    destination: MainView(userRole: selectedRole)
                ) {
                    Text(NSLocalizedString("Continue", comment: ""))
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 50)
                }
                .disabled(!termsAccepted)
                .opacity(termsAccepted ? 1.0 : 0.5)
                .padding(.top, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
            .background(Color.blue)
            
        }
        .onAppear(perform: {
            UserDefaults.standard.welcomeScreenShown = true
        })
    }
}
    
struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}
