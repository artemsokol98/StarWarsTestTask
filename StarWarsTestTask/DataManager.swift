//
//  DataManager.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 16.12.2022.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    var filmsCaching = [FilmsCaching]()
}
