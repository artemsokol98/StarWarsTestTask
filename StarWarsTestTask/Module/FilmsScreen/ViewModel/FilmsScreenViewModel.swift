//
//  FilmsScreenViewModel.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import Foundation
import UIKit
import CoreData

protocol FilmsScreenViewModelProtocol: AnyObject {
    //var viewController: ViewController { get }
    var charecters: [[String]] { get set }
    var films: Films! { get set }
    var parsedFilms: [FilmsTableViewCellModel] { get set }
    var parsedFilmsSearched: [FilmsTableViewCellModel] { get set }
    func downloadingFilms(completion: @escaping (Result<Void, Error>) -> Void)
    func clearCache()
}

class FilmsScreenViewModel: FilmsScreenViewModelProtocol {
    var films: Films!
    var parsedFilms = [FilmsTableViewCellModel]()
    var parsedFilmsSearched = [FilmsTableViewCellModel]()
    var charecters = [[String]]()
    //var validFilmsForSearch = 
    
    //var viewController: ViewController
    // MARK: - Core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func clearCache() {
        let storeContainer =
            persistentContainer.persistentStoreCoordinator
        
        for store in storeContainer.persistentStores {
            do {
            try storeContainer.destroyPersistentStore(
                at: store.url!,
                ofType: store.type,
                options: nil
            )
            } catch {
                
            }
        }
        
        persistentContainer = NSPersistentContainer(name: "StarWarsTestTask")
    }
    
    func createItemFilms(item: FilmsTableViewCellModel) {
        let newItem = FilmsCaching(context: context)
        newItem.filmName = item.FilmName
        newItem.directorName = item.DirectorName
        newItem.producerName = item.ProducerName
        newItem.yearRelease = item.YearRelease
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func createItemArrayCharacters(item: [String]) {
        let newItem = CharactersCaching(context: context)
        newItem.character = item
    }
    
    func getAllItems() -> [FilmsTableViewCellModel] {
        var tableInfo = [FilmsTableViewCellModel]()
        do {
            let filmsCaching = try context.fetch(FilmsCaching.fetchRequest())
            for item in filmsCaching {
                let tvc = FilmsTableViewCellModel(
                    FilmName: item.filmName ?? "Unknown Title",
                    DirectorName: item.directorName ?? "Unknown Title",
                    ProducerName: item.producerName ?? "Unknown Title",
                    YearRelease: item.yearRelease ?? "Unknown Title"
                )
                tableInfo.append(tvc)
            }
            print(filmsCaching.count)
        } catch {
            
        }
        return tableInfo
    }
    
    func getCharacters() -> [[String]] {
        var charactersInfo = [[String]]()
        do {
            let charact = try context.fetch(CharactersCaching.fetchRequest())
            for item in charact {
                charactersInfo.append(item.character ?? ["no info"])
            }
        } catch {
            
        }
        print(charactersInfo)
        return charactersInfo
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
    
    func deleteItemsFromEntity() {
        
        let fetchRequest: NSFetchRequest<FilmsCaching>
        fetchRequest = FilmsCaching.fetchRequest()
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            try context.save()
        } catch {
            
        }
        
       
    }
    
    func downloadingFilms(completion: @escaping (Result<Void, Error>) -> Void) {
        
        if entityIsEmpty(entity: "FilmsCaching") {
            NetworkManager.shared.fetchFilms { films in
                switch films {
                case .success(let films):
                    DispatchQueue.main.async {
                        self.films = films
                        guard let results = films.results else { return }
                        for item in results {
                            self.charecters.append(item.characters)
                            self.createItemArrayCharacters(item: item.characters)
                        }
                        self.parsedFilms = self.parsingFilms(films: films)
                        completion(.success(()))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }
        } else {
            //deleteItemsFromEntity()
            self.charecters = getCharacters()
            self.parsedFilms = getAllItems()
        }
        
        
        
    }
    
    func parsingFilms(films: Films) -> [FilmsTableViewCellModel] {
        var tableInfo = [FilmsTableViewCellModel]()
        guard let results = films.results else { print("Error unwrapping"); return [FilmsTableViewCellModel]() }; #warning("remove empty array")
        for item in results {
            let tvc = FilmsTableViewCellModel(
                FilmName: item.title ?? "Unknown Title",
                DirectorName: item.director ?? "Unknown Director",
                ProducerName: item.producer ?? "Unknown Producer",
                YearRelease: item.releaseDate ?? "Unknown Release Date"
            )
            tableInfo.append(tvc)
            createItemFilms(item: tvc)
            //DataManager.shared.filmsCaching.append(<#T##newElement: FilmsCaching##FilmsCaching#>)
        }
        return tableInfo
    }
    
}
