//
//  FilmsScreenViewModelProtocol.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 19.12.2022.
//

import Foundation

protocol FilmsScreenViewModelProtocol: AnyObject {
    //var charecters: [[String]] { get set }
    var films: Films! { get set }
    var parsedFilms: [FilmsTableViewCellModel] { get set }
    var parsedFilmsSearched: [FilmsTableViewCellModel] { get set }
    func downloadingFilms(completion: @escaping (Result<Void, Error>) -> Void)
}
