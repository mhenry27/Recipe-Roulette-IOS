//
//  SettingsView.swift
//  Recipe Roulette
//
//

import SwiftUI

import SwiftUI

struct SettingsView: View {
    @AppStorage(SettingsKeys.preferredCuisine) private var preferredCuisine: String = "Any"
    @AppStorage(SettingsKeys.maxCookTime) private var maxCookTime: Int = 60
    @AppStorage(SettingsKeys.vegetarianOnly) private var vegetarianOnly: Bool = false
    @AppStorage(SettingsKeys.notificationHour) private var notificationHour: Int = 18 // 6pm
    
    @State private var notificationMinute: Int = 0
    @State private var notificationsEnabled: Bool = false
    
    let cuisines = ["Any", "Beef", "Chicken", "Dessert", "Pasta", "Seafood", "Vegetarian"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Recipe Filters") {
                    Picker("Preferred Cuisine", selection: $preferredCuisine) {
                        ForEach(cuisines, id: \.self) { cuisine in
                            Text(cuisine)
                        }
                    }
                    Stepper("Max Cook Time (approx): \(maxCookTime) min", value: $maxCookTime, in: 10...180, step: 10)
                    Toggle("Vegetarian Only", isOn: $vegetarianOnly)
                        .tint(.color)
                }
                
                Section("Notifications") {
                    Toggle("Daily Recipe Notification", isOn: $notificationsEnabled)
                        .tint(.color)
                        .onChange(of: notificationsEnabled) { enabled in
                            if enabled {
                                NotificationManager.shared.requestAuthorization()
                                scheduleNotification()
                            } else {
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily_recipe"])
                            }
                        }
                    
                    HStack {
                        Stepper("Hour: \(notificationHour)", value: $notificationHour, in: 0...23)
                        Stepper("Min: \(notificationMinute)", value: $notificationMinute, in: 0...59, step: 15)
                    }
                    .onChange(of: notificationHour) { _ in
                        if notificationsEnabled { scheduleNotification() }
                    }
                    .onChange(of: notificationMinute) { _ in
                        if notificationsEnabled { scheduleNotification() }
                    }
                }
                
                Section("Appearance") {
                    Text("Custom colors are defined in the asset catalog as AccentColor, BackgroundColor, CardColor, CardAccentColor, ChipColor.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    private func scheduleNotification() {
        NotificationManager.shared.scheduleDailyRecipeNotification(
            hour: notificationHour,
            minute: notificationMinute
        )
    }
}

#Preview {
    SettingsView()
}
