//
//  MyListViewModel.swift
//  ReminderApp
//
//  Created by mert can çifter on 13.03.2023.
//

import CoreData
import SwiftUI

@MainActor
class MyListViewModel: NSObject, ObservableObject {
    
    @Published var myList = [MyList]()
    @Published var reminders = [Reminder]()
        
    private var reminderStatsBuilder = ReminderStatsBuilder()
    @Published var reminderStatsValues = ReminderStatsValues()
    
    private let fetchedResultController: NSFetchedResultsController<MyList>
    private (set) var context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchedResultController = NSFetchedResultsController(fetchRequest: MyList.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
            
            guard let list = fetchedResultController.fetchedObjects else {
                return
            }
            
            self.myList = list
        } catch {
            
        }
    }
    
    func getRemindersByTitle(title: String) {
        let fetchController = NSFetchedResultsController(fetchRequest: ReminderService.getRemindersBySearchTerm(title), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        do {
            try fetchController.performFetch()
            
            guard let list = fetchController.fetchedObjects else {
                self.reminders = []
                return
            }
            
            self.reminders = list
        } catch {
            
        }
    }
    
    func addList(name: String, color: UIColor){
        do {
            try ReminderService.saveMyList(name, color)
        } catch {
            
        }
    }
    
    func dailyReportFetch(){
        reminderStatsValues = reminderStatsBuilder.build(myListResults: myList)
    }
    
    func getRemindersByType(type: ReminderStatType) -> [Reminder] {
        var fc: NSFetchedResultsController<Reminder>? = nil
        
        switch type {
        case .all:
            fc = NSFetchedResultsController(fetchRequest: ReminderService.remindersByStatType(statType: .all), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        case .completed:
            fc = NSFetchedResultsController(fetchRequest: ReminderService.remindersByStatType(statType: .completed), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        case .today:
            fc = NSFetchedResultsController(fetchRequest: ReminderService.remindersByStatType(statType: .today), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        case .scheduled:
            fc = NSFetchedResultsController(fetchRequest: ReminderService.remindersByStatType(statType: .scheduled), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        
        do {
            try fc?.performFetch()
            
            guard let list = fc?.fetchedObjects else {
                return []
            }
            
            return list
            
        } catch {
            
        }
        
        return []
    }
}

extension MyListViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let list = controller.fetchedObjects as? [MyList] else {
            return
        }
        
        self.myList = list
    }
}
