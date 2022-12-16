//
//  PersonsViewModel.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import Foundation

protocol PersonsViewModelProtocol {
    func downloadingPersons(apiStrings: [String], completion: @escaping (Result<Void, Error>) -> Void)
    var tableViewPersons: [PersonTableViewCellModel] { get set }
}

class PersonsViewModel: PersonsViewModelProtocol {
    
    var tableViewPersons = [PersonTableViewCellModel]()
    
    weak var filmsViewModel: FilmsScreenViewModelProtocol?
    
    func downloadingPersons(apiStrings: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        
//        guard let persons = filmsViewModel?.films.results?[index].characters else { return }
//        print(persons)
        let dispatchGroup = DispatchGroup()
        
        for item in apiStrings {
            dispatchGroup.enter()
            NetworkManager.shared.fetchPerson(personApiString: item) { result in
                dispatchGroup.leave()
                switch result {
                case .success(let person):
                    DispatchQueue.main.async {
                        print("123 \(person)")
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
                    }
                }
                
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
        
    }
}


