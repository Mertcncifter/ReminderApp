//
//  MyList+CoreDataClass.swift
//  ReminderApp
//
//  Created by mert can çifter on 10.03.2023.
//

import Foundation
import CoreData

@objc(MyList)
public class MyList: NSManagedObject {
    var remindersArray: [Reminder] {
        reminders?.allObjects.compactMap { ($0 as! Reminder) } ?? []
    }
}


