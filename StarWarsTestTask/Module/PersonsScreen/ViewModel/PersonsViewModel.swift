//
//  PersonsViewModel.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import UIKit
import CoreData

class PersonsViewModel: PersonsViewModelProtocol {
    var tableViewPersons = [PersonTableViewCellModel]()
    
    func downloadingPersons(numberOfMovie: Int, apiStrings: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        if let data = UserDefaults.standard.data(forKey: "\(numberOfMovie)") {
            do {
                let tvm = try JSONDecoder().decode([PersonTableViewCellModel].self, from: data)
                if tvm.count > 0 {
                    self.tableViewPersons = tvm
                    completion(.success(()))
                }
            } catch {
                
            }
        } else {
        let dispatchGroup = DispatchGroup()
        for item in apiStrings {
            dispatchGroup.enter()
            NetworkManager.shared.fetchPerson(personApiString: item) { result in
                dispatchGroup.leave()
                switch result {
                case .success(let person):
                    DispatchQueue.main.async {
                        let tvm = PersonTableViewCellModel(
                            namePerson: person.name ?? "Unknown Info",
                            sexPerson: person.gender ?? "Unknown Info",
                            bornDatePerson: person.birthYear ?? "Unknown Info",
                            homeworld: person.homeworld
                        )
                        self.tableViewPersons.append(tvm)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            do {
                if self.tableViewPersons.count > 0 {
                    let data = try JSONEncoder().encode(self.tableViewPersons)
                    UserDefaults.standard.set(data, forKey: "\(numberOfMovie)")
                }
            } catch {
                
            }
            completion(.success(()))
            }
        }
    }
    
    // MARK: - CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createItemPerson(item: PersonTableViewCellModel) {
        let newItem = PersonsCaching(context: context)
        newItem.namePerson = item.namePerson
        newItem.sexPerson = item.sexPerson
        newItem.bornDatePerson = item.bornDatePerson
        newItem.homeworld = item.homeworld
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func getAllPersons() -> [PersonTableViewCellModel] {
        var tableInfo = [PersonTableViewCellModel]()
        do {
            let personsCaching = try context.fetch(PersonsCaching.fetchRequest())
            for item in personsCaching {
                let tvc = PersonTableViewCellModel(
                    namePerson: item.namePerson ?? "Unknown Info",
                    sexPerson: item.sexPerson ?? "Unknown Info",
                    bornDatePerson: item.bornDatePerson ?? "Unknown Info",
                    homeworld: item.homeworld
                )
                tableInfo.append(tvc)
            }
        } catch {
            
        }
        return tableInfo
    }
}


