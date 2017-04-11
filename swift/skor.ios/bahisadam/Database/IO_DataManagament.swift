//
//  IO_DataManagament.swift
//  IO Core Data Helper
//
//  Created by ilker özcan on 23/02/15.
//  Copyright (c) 2015 ilkerozcan. All rights reserved.
//

import CoreData
import Foundation

/// Core data helper class
public class IO_DataManagement {
	
	let databaseName: String
	let databaseResourceName: String
	
	struct DataManagementVariables {
		
		static var ManagedObjectContext: NSManagedObjectContext?
		static var ObjectModel: NSManagedObjectModel!
	}
	
	private static var Singleton: IO_DataManagement!
	
	/// Core data helper class
	public init(databaseName: String, databaseResourceName: String) {
		
		self.databaseName = databaseName
		self.databaseResourceName = databaseResourceName
		
		IO_DataManagement.Singleton = self
	}
	
	/// Core data shared instance
	public class var SharedInstance: IO_DataManagement {

		if(IO_DataManagement.Singleton == nil) {
			NSLog("\n-------------\nWarning!\n-------------\nData Management is not inited!\n")
			abort()
		}
		
		return IO_DataManagement.Singleton
	}
 
	// MARK: - Core Data stack
	private lazy var applicationDocumentsDirectory: URL = {
		// The directory the application uses to store the Core Data store file.
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls[urls.count-1] 
		}()
	
	private func _managedObjectModel() -> NSManagedObjectModel {
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		let modelURL = Bundle.main.url(forResource: self.databaseResourceName, withExtension: "momd")!
		return NSManagedObjectModel(contentsOf: modelURL)!
	}
	
	/// Get NSManagedObjectModel
	public var managedObjectModel: NSManagedObjectModel {
		
		if(DataManagementVariables.ObjectModel == nil) {
			DataManagementVariables.ObjectModel = self._managedObjectModel()
		}
		
		return DataManagementVariables.ObjectModel
	}
	
	private var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
		
		return self.getPersistentStoreCoordinator()
	}
	
	private var _managedObjectContext: NSManagedObjectContext? {
		
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		let coordinator = self.persistentStoreCoordinator
		let managedObjectContext = NSManagedObjectContext()

		if coordinator == nil {
			print("Warning !!! Application using different sqllite version! all data will have deleted!")
			//self.persistentStoreCoordinator					= self.getPersistentStoreCoordinator()
			
			managedObjectContext.persistentStoreCoordinator	= self.persistentStoreCoordinator
			return managedObjectContext
		}
		
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
	}
	
	/// Get NSManagedObjectContext
	public var managedObjectContext: NSManagedObjectContext? {
		
		if(DataManagementVariables.ManagedObjectContext == nil) {
			DataManagementVariables.ManagedObjectContext = self._managedObjectContext
		}
		
		return DataManagementVariables.ManagedObjectContext
	}
	
	private func getPersistentStoreCoordinator() -> NSPersistentStoreCoordinator? {
		
		// The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		// Create the coordinator and store
		var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		let url = self.applicationDocumentsDirectory.appendingPathComponent(self.databaseName)
		var error: NSError? = nil
		let options			= [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
		do {
			try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
		} catch let error1 as NSError {
			error = error1
			// Replace this with code to handle the error appropriately.
			NSLog("\n\n Warning! \n Database completly changed!!!!!\n Core Data migration or versioning rules not found \n Application will be crashed!\n\n*****************\n")
			print(error?.description ?? "An error occured!")

			#if CORE_DATA_DEVELOPMENT
			// delete local database and recreate it.
			do {
				try FileManager.default.removeItem(at: url)
			} catch {
				print("File manager error!");
			}
			
			coordinator		= nil
			#else
			// if database template changed and does not have any migration rules or versioning the application will crash!
			NSLog("\n\n Warning! \n Database completly changed!!!!!\n no migration rules application will be crash\n")
			abort()
			#endif
		}
		
		return coordinator
	}
	
	/// Delete database
	public func deleteSql() {
		
		_	= Bundle.main.url(forResource: self.databaseResourceName, withExtension: "momd")!
		let url = self.applicationDocumentsDirectory.appendingPathComponent(self.databaseName)
		do {
			try FileManager.default.removeItem(at: url)
		} catch _ {
		}
		DataManagementVariables.ManagedObjectContext = nil
		DataManagementVariables.ObjectModel = nil
		
		print("Warning! \n Local database deleted! \n Something wrong!");
	}
	
	// MARK: - Core Data Saving support
	
	/// Save changes
	public func saveContext () {
		
		if let moc = self.managedObjectContext {
			var error: NSError? = nil
			if moc.hasChanges {
				do {
					try moc.save()
				} catch let error1 as NSError {
					error = error1
					// Replace this implementation with code to handle the error appropriately.
					// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
					NSLog("\n-----------\nWarning!!! \nUnresolved error \(error), \(error!.userInfo)")
					//abort()
				}
			}
			
			if(error != nil) {
				print("Core data save error! \(error?.description)");
			}
		}
	}
}



