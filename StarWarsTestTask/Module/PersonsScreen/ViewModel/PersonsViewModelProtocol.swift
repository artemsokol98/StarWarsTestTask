//
//  PersonsViewModelProtocol.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 19.12.2022.
//

import Foundation

protocol PersonsViewModelProtocol {
    func downloadingPersons(numberOfMovie: Int, apiStrings: [String], completion: @escaping (Result<Void, Error>) -> Void)
    var tableViewPersons: [PersonTableViewCellModel] { get set }
}
