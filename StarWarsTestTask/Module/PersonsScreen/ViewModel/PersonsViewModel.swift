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
        let dispatchGroup = DispatchGroup()
        for item in apiStrings {
            dispatchGroup.enter()
            do {
                let result = try? DataManager.shared.searchPesonsInDataBase(entity: "PersonsCaching", apiString: item)
                guard let result = result else { throw CoreDataErrors.CouldntGetData }
                self.tableViewPersons.append(result)
                dispatchGroup.leave()
            } catch {
                NetworkManager.shared.fetchInformation(urlString: item, expectingType: Person.self) { result in
                    dispatchGroup.leave()
                    switch result {
                    case .success(let person):
                        guard let person = person as? Person else { return }
                        DispatchQueue.main.async {
                            let tvm = PersonTableViewCellModel(
                                namePerson: person.name ?? "Unknown Info",
                                sexPerson: person.gender ?? "Unknown Info",
                                bornDatePerson: person.birthYear ?? "Unknown Info",
                                homeworld: person.homeworld
                            )
                            self.tableViewPersons.append(tvm)
                            self.createItemPerson(item: tvm, apiString: item)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print(error.localizedDescription)
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    // MARK: - CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createItemPerson(item: PersonTableViewCellModel, apiString: String) {
        let newItem = PersonsCaching(context: context)
        newItem.namePerson = item.namePerson
        newItem.sexPerson = item.sexPerson
        newItem.bornDatePerson = item.bornDatePerson
        newItem.homeworld = item.homeworld
        newItem.characterApiString = apiString
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


