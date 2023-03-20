//
//  ReminderAppApp.swift
//  ReminderApp
//
//  Created by mert can çifter on 10.03.2023.
//

import SwiftUI
import UserNotifications

@main
struct ReminderAppApp: App {
    
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { granted, error in
            if granted {
                
            }
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            
            let viewContext = CoreDataProvider.shared.persistentContainer.viewContext
            HomeView(vm: MyListViewModel(context: viewContext))
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
