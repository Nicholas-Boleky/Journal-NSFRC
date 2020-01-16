//
//  EntryController.swift
//  Journal+NSFRC
//
//  Created by Karl Pfister on 5/9/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    static let sharedInstance = EntryController()
    // Create a var to access our fetched results controller
    var fetchedResultsController: NSFetchedResultsController<Entry>
    // create an init that gives our fetched results controller a value
    init() {
        // step 2: create fetchRequest in order to fulfill the parameter requirement of the resultsController initializer
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        //step3 accessed the sortdescriptors property on our fetch reuest and told it we wanted our results sorted by timestamp in descending order
       
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        //step 4: filled in parameters our our results controller initializer with our fetch request, our context from our coreDataStack, and passed in nil for section and cache as they are not needed for this app.
        //step 1: created a let called resultsController that was  NSFetchedResultsController initialized from the vavailable initializer
        let resultsController: NSFetchedResultsController<Entry> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName:
            nil)
    //step 5 we assigned our results controller constant as the value of our fetchedResultsController variable (this got rid of the need to return in our initializer
        fetchedResultsController = resultsController
      //step 6 accessed our fetched results controller and try to run the performFetch() func given to us by apple
        //because this func throws we need to wrap in do/try/catch to catch the error if there is one
        do {
        try fetchedResultsController.performFetch()
        } catch {
            print("there was an error performing fetch: \(error.localizedDescription)")
        }
    }
//    var entries: [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
//    }
    
    //CRUD
    func createEntry(withTitle: String, withBody: String) {
        let _ = Entry(title: withTitle, body: withBody)
        
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, newTitle: String, newBody: String) {
        entry.title = newTitle
        entry.body = newBody
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        entry.managedObjectContext?.delete(entry)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
             try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object. Items not saved!! \(#function) : \(error.localizedDescription)")
        }
    }
}
