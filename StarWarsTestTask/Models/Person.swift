//
//  Person.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import Foundation

struct Person: Decodable {
    let name, height, mass, hairColor: String?
    let skinColor, eyeColor, birthYear, gender: String?
    let homeworld: String?
    let films, species: [String]?
    let vehicles, starships: [String]?
    let created, edited: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films, species, vehicles, starships, created, edited, url
    }
}
