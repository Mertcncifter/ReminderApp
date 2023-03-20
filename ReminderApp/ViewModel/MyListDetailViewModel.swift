//
//  MyListDetailViewModel.swift
//  ReminderApp
//
//  Created by mert can çifter on 13.03.2023.
//

import Foundation
import CoreData

@MainActor
class MyListDetailViewModel: NSObject, ObservableObject {
    
    @Published var reminders = [Reminder]()
    let myList: MyList
    private let fetchedResultController: NSFetchedResultsController<Reminder>
    private (set) var context: NSManagedObjectContext
    init(context: NSManagedObjectContext,myList: MyList) {
        self.context = context
        self.myList = myList
        fetchedResultController = NSFetchedResultsController(fetchRequest: ReminderService.getRemindersByList(myList: myList), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
            
            guard let list = fetchedResultController.fetchedObjects else {
                return
            }
            
            self.reminders = list
        } catch {
            
        }
    }
    
    func addReminder(myList: MyList,title: String){
        do {
            try ReminderService.saveReminderToMyList(myList: myList, reminderTitle: title)
        } catch {
            
        }
    }
}

extension MyListDetailViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let list = controller.fetchedObjects as? [Reminder] else {
            return
        }
        
        self.reminders = list
    }
}





/*
@MainActor
class MyListDetailViewModel: NSObject,ObservableObject {
    
    let myList: MyList
    @Published var reminders = [Reminder]()
    var context: NSManagedObjectContext?
    
    lazy var fetchedResultsController : NSFetchedResultsController<Reminder> = {
        let frc = NSFetchedResultsController<Reminder>(fetchRequest: ReminderService.getRemindersByList(myList: myList), managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    init(myList: MyList) {
        self.myList = myList
    }
    
    func fetch(){
        do {
            try fetchedResultsController.performFetch()
            
            guard let list = fetchedResultsController.fetchedObjects else {
                return
            }
            
            self.reminders = list
        } catch {
            
        }
    }
    
    func addReminder(myList: MyList,title: String){
        do {
            try ReminderService.saveReminderToMyList(myList: myList, reminderTitle: title)
        } catch {
            
        }
    }
}


extension MyListDetailViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let list = controller.fetchedObjects as? [Reminder] else {
            return
        }
        
        self.reminders = list
    }
}
*/
