//
//  DataManager.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 16.12.2022.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    static let shared = DataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func clearCache() {
        let storeContainer = persistentContainer.persistentStoreCoordinator
        for store in storeContainer.persistentStores {
            do {
            try storeContainer.destroyPersistentStore(
                at: store.url!,
                ofType: store.type,
                options: nil
            )
            } catch {
                
            }
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }
        persistentContainer = NSPersistentContainer(name: "StarWarsTestTask")
    }
    
    func entityIsEmpty(entity: String) -> Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let count = try context.count(for: request)
            return count == 0
        } catch let error as NSError {
            print("Error: \(error.debugDescription)")
            return true
        }
    }
    
    func searchPesonsInDataBase(entity: String, apiString: String) throws -> PersonTableViewCellModel? {
        let request = PersonsCaching.fetchRequest() as NSFetchRequest<PersonsCaching>//NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.predicate = NSPredicate(format: "characterApiString == %@", apiString)
        guard let data = try? context.fetch(request) else { throw CoreDataErrors.CouldntGetData }
        guard let name = data.first?.namePerson else { throw CoreDataErrors.CouldntGetData }
        let parsedData = PersonTableViewCellModel(
            namePerson: data.first?.namePerson ?? "Unknowed",
            sexPerson: data.first?.sexPerson ?? "Unknowed",
            bornDatePerson: data.first?.bornDatePerson ?? "Unknowed",
            homeworld: data.first?.homeworld)
        //guard let homeworld = data.first?.homeworld, let name = data.first?.namePerson else { return "Error"}
        //print(name)
        //print(homeworld)
        return parsedData
    }
}

enum CoreDataErrors: Error {
    case CouldntGetData
}
