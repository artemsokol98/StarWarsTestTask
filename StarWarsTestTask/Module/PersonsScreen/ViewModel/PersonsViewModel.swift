//
//  PersonsViewModel.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import Foundation
import UIKit
import CoreData

protocol PersonsViewModelProtocol {
    func downloadingPersons(apiStrings: [String], completion: @escaping (Result<Void, Error>) -> Void)
    var tableViewPersons: [PersonTableViewCellModel] { get set }
}

class PersonsViewModel: PersonsViewModelProtocol {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tableViewPersons = [PersonTableViewCellModel]()
    
    weak var filmsViewModel: FilmsScreenViewModelProtocol?
    
    func downloadingPersons(apiStrings: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        
//        guard let persons = filmsViewModel?.films.results?[index].characters else { return }
        if DataManager.shared.entityIsEmpty(entity: "PersonsCaching") {
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
                            self.createItemPerson(item: tvm)
                            self.tableViewPersons.append(tvm)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print(error.localizedDescription)
                        }
                    }
                    
                }
            }
            dispatchGroup.notify(queue: .main) {
                completion(.success(()))
            }
        } else {
            self.tableViewPersons = getAllPersons() // один и тот же набор скачивается вместо разных персонажей
        }
        
        
    }
    
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


