//
//  NetworkManager.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 14.12.2022.
//

import Foundation

typealias CompletionHandlerForFilms = (Result<Films,Error>) -> Void
typealias CompletionHandlerForPerson = (Result<Person,Error>) -> Void
typealias CompletionHandlerForPlanet = (Result<Planet,Error>) -> Void

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let apiString = "https://swapi.dev/api/films/"
    
    // ?format=json
    func fetchFilms(completion: @escaping CompletionHandlerForFilms) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        
        guard let url = URL(string: apiString) else { return }
        session.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let decodedData = try? JSONDecoder().decode(Films.self, from: data) {
                    print(decodedData)
                    completion(.success(decodedData)); #warning("обработку ошибок сделать")
                }
            }
        }.resume()
    }
    
    func fetchPerson(personApiString: String, completion: @escaping CompletionHandlerForPerson) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        
        guard let url = URL(string: personApiString) else { return }
        session.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let decodedData = try? JSONDecoder().decode(Person.self, from: data) {
                    print(decodedData)
                    completion(.success(decodedData)); #warning("обработку ошибок сделать")
                }
            }
        }.resume()
    }
    
    func fetchPlanet(planetApiString: String, completion: @escaping CompletionHandlerForPlanet) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        
        guard let url = URL(string: planetApiString) else { return }
        session.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let decodedData = try? JSONDecoder().decode(Planet.self, from: data) {
                    print(decodedData)
                    completion(.success(decodedData)); #warning("обработку ошибок сделать")
                }
            }
        }.resume()
    }
}
