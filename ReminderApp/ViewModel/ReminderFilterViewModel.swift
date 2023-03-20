//
//  ReminderFilterViewModel.swift
//  ReminderApp
//
//  Created by mert can çifter on 15.03.2023.
//

import Foundation
import CoreData

@MainActor
class ReminderFilterViewModel: NSObject, ObservableObject {
    
    @Published var reminders = [Reminder]()

    private let fetchedResultController: NSFetchedResultsController<Reminder>
    private (set) var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext,type: ReminderStatType) {
        self.context = context
        switch type {
        case .all:
            fetchedResultController = NSFetchedResultsController(fetchRequest: ReminderService.remindersByStatType(statType: .all), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        case .completed:
            fetchedResultController = NSFetchedResultsController(fetchRequest: ReminderService.remindersByStatType(statType: .completed), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        case .today:
            fetchedResultController = NSFetchedResultsController(fetchRequest: ReminderService.remindersByStatType(statType: .today), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        case .scheduled:
            fetchedResultController = NSFetchedResultsController(fetchRequest: ReminderService.remindersByStatType(statType: .scheduled), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
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
}

extension ReminderFilterViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let list = controller.fetchedObjects as? [Reminder] else {
            return
        }
        
        self.reminders = list
    }
}

