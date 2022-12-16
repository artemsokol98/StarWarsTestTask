//
//  FilmsScreenViewModel.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import Foundation

protocol FilmsScreenViewModelProtocol: AnyObject {
    //var viewController: ViewController { get }
    var films: Films! { get set }
    var parsedFilms: [FilmsTableViewCellModel] { get set }
    var parsedFilmsSearched: [FilmsTableViewCellModel] { get set }
    func downloadingFilms(completion: @escaping (Result<Void, Error>) -> Void)
}

class FilmsScreenViewModel: FilmsScreenViewModelProtocol {
    var films: Films!
    var parsedFilms = [FilmsTableViewCellModel]()
    var parsedFilmsSearched = [FilmsTableViewCellModel]()
    //var validFilmsForSearch = 
    
    //var viewController: ViewController
    
    func downloadingFilms(completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.fetchFilms { films in
            switch films {
            case .success(let films):
                DispatchQueue.main.async {
                    self.films = films
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
        }
        return tableInfo
    }
    
}
