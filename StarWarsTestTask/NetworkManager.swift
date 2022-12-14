//
//  NetworkManager.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 14.12.2022.
//

import Foundation

typealias CompletionHadler = () -> Void

class NetworkManager {
    
    static let apiString = "https://swapi.dev/api/films/"
    // ?format=json
    static func fetchFilms(completion: @escaping CompletionHadler) {
        guard let url = URL(string: apiString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let decodedData = try? JSONDecoder().decode(Films.self, from: data) {
                    print(decodedData)
                    completion()
                }
            }
        }.resume()
    }
}
