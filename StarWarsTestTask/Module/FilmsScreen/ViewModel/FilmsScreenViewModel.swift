//
//  FilmsScreenViewModel.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import UIKit
import CoreData

class FilmsScreenViewModel: FilmsScreenViewModelProtocol {
    var films: Films!
    var parsedFilms = [FilmsTableViewCellModel]()
    var parsedFilmsSearched = [FilmsTableViewCellModel]()
    //var charecters = [[String]]()
    
    // MARK: - Network and parsing
    
    func downloadingFilms(completion: @escaping (Result<Void, Error>) -> Void) {
        
        if DataManager.shared.entityIsEmpty(entity: "FilmsCaching") {
            NetworkManager.shared.fetchInformation(urlString: "https://swapi.dev/api/films/", expectingType: Films.self) { films in
                switch films {
                case .success(let films):
                    DispatchQueue.main.async {
                        guard let films = films as? Films else { return }
                        self.films = films
                        /*
                        guard let results = films.results else { return }
                        for item in results {
                            //self.charecters.append(item.characters)
                            //self.createItemArrayCharacters(item: item.characters)
                        }
                         */
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
            //self.charecters = getCharacters()
            self.parsedFilms = getAllItems()
        }
    }
    
    func parsingFilms(films: Films) -> [FilmsTableViewCellModel] {
        var tableInfo = [FilmsTableViewCellModel]()
        guard let results = films.results else { print("Error unwrapping"); return [FilmsTableViewCellModel]() }
        for item in results {
            let tvc = FilmsTableViewCellModel(
                FilmName: item.title ?? "Unknown Title",
                DirectorName: item.director ?? "Unknown Director",
                ProducerName: item.producer ?? "Unknown Producer",
                YearRelease: item.releaseDate ?? "Unknown Release Date",
                Characters: item.characters
            )
            tableInfo.append(tvc)
            createItemFilms(item: tvc)
        }
        return tableInfo
    }
    
    // MARK: - Core data
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func createItemFilms(item: FilmsTableViewCellModel) {
        let newItem = FilmsCaching(context: context)
        newItem.filmName = item.FilmName
        newItem.directorName = item.DirectorName
        newItem.producerName = item.ProducerName
        newItem.yearRelease = item.YearRelease
        newItem.character = item.Characters
        do {
            try context.save()
        } catch {
            
        }
    }
    /*
    func createItemArrayCharacters(item: [String]) {
        let newItem = CharactersCaching(context: context)
        newItem.character = item
    }
    */
    func getAllItems() -> [FilmsTableViewCellModel] {
        var tableInfo = [FilmsTableViewCellModel]()
        do {
            let filmsCaching = try context.fetch(FilmsCaching.fetchRequest())
            for item in filmsCaching {
                let tvc = FilmsTableViewCellModel(
                    FilmName: item.filmName ?? "Unknown Title",
                    DirectorName: item.directorName ?? "Unknown Title",
                    ProducerName: item.producerName ?? "Unknown Title",
                    YearRelease: item.yearRelease ?? "Unknown Title",
                    Characters: item.character ?? ["Unknown character"]
                )
                tableInfo.append(tvc)
            }
        } catch {
            
        }
        return tableInfo
    }
    /*
    func getCharacters() -> [[String]] {
        var charactersInfo = [[String]]()
        do {
            let charact = try context.fetch(CharactersCaching.fetchRequest())
            for item in charact {
                charactersInfo.append(item.character ?? ["no info"])
            }
        } catch {
            
        }
        return charactersInfo
    }
    */
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
    
   
    
}
