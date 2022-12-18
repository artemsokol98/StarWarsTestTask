//
//  PersonTableViewCellModel.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import Foundation

struct PersonTableViewCellModel: Codable {
    let namePerson: String
    let sexPerson: String
    let bornDatePerson: String
    let homeworld: String?
}
