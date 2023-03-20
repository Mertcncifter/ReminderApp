//
//  ReminderListView.swift
//  ReminderApp
//
//  Created by mert can çifter on 13.03.2023.
//

import SwiftUI


struct ReminderListView: View {
    
    let reminders: [Reminder]
    @State private var selectedReminder: Reminder?
    @State private var showReminderDetail: Bool = false
    @State private var loading: Bool = false
    
    private func reminderCheckedChanged(reminder: Reminder,isCompleted: Bool){
        var editConfig = ReminderEditConfig(reminder: reminder)
        editConfig.isCompleted = isCompleted
        
        do {
            let _ = try ReminderService.updateReminder(reminder: reminder, editConfig: editConfig)
        } catch {
            
        }
    }
    
    private func isReminderSelected(_ reminder: Reminder) -> Bool {
        selectedReminder?.objectID == reminder.objectID
    }
    
    private func deleteReminder(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let reminder = reminders[index]
            do {
                try ReminderService.deleteReminder(reminder: reminder)
            } catch {
                
            }
        }
    }
    
    var body: some View {
        
        VStack {
            List {
                if !loading {
                    ForEach(reminders,id: \.self) { reminder in
                        ReminderCellView(reminder: reminder,isSelected: isReminderSelected(reminder)) { event in
                            switch event {
                            case .onInfo:
                                showReminderDetail = true
                            case .onCheckedChange(let reminder,let isCompleted):
                                reminderCheckedChanged(reminder: reminder,isCompleted: isCompleted)
                            case .onSelect(let reminder):
                                selectedReminder = reminder
                            }
                        }
                    }.onDelete(perform: deleteReminder)
                }
            }
        }.sheet(isPresented: $showReminderDetail) {
            ReminderDetailView(reminder: Binding($selectedReminder)!) { reminder, editConfig in
                loading = true
                do {
                    let updated = try ReminderService.updateReminder(reminder: reminder, editConfig: editConfig)
                    
                    if updated {
                        if reminder.reminderDate != nil || reminder.reminderTime != nil {
                            let userData = UserData(title: reminder.title, body: reminder.notes, date: reminder.reminderDate, time: reminder.reminderTime)
                            NotificationManager.scheduleNotification(userData: userData)
                        }
                    }
                } catch {
                    
                }
                
                loading = false
            }
        }
    }
}
