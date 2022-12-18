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
    let sessionConfig = URLSessionConfiguration.default
    
    func fetchFilms(completion: @escaping CompletionHandlerForFilms) {
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        
        guard let url = URL(string: apiString) else { return }
        session.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let decodedData = try? JSONDecoder().decode(Films.self, from: data) {
                    completion(.success(decodedData))
                }
            } else {
                guard let error = error else { return }
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPerson(personApiString: String, completion: @escaping CompletionHandlerForPerson) {
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        
        guard let url = URL(string: personApiString) else { return }
        session.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let decodedData = try? JSONDecoder().decode(Person.self, from: data) {
                    completion(.success(decodedData))
                }
            } else {
                guard let error = error else { return }
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPlanet(planetApiString: String, completion: @escaping CompletionHandlerForPlanet) {
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        
        guard let url = URL(string: planetApiString) else { return }
        session.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let decodedData = try? JSONDecoder().decode(Planet.self, from: data) {
                    print(decodedData)
                    completion(.success(decodedData))
                }
            } else {
                guard let error = error else { return }
                completion(.failure(error))
            }
        }.resume()
    }
    
    /*
    func fetchInformation<T: Decodable>(urlString: String, expectingType: T.Type, completion: @escaping (Result<T.Type,Error>) -> Void) {
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        guard let url = URL(string: urlString) else { return }
        
        session.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                    switch expectingType {
                    case is Films.Type:
                        guard let castedData = decodedData as? Films else { return }
                        //completion(.success(castedData))
                    case is Person.Type:
                        guard let castedData = decodedData as? Person else { return }
                        //completion(.success(castedData))
                    case is Planet.Type:
                        guard let castedData = decodedData as? Person else { return }
                        //completion(.success(castedData))
                    default: print("Error decoding")
                    }
                }
            } else {
                guard let error = error else { return }
                completion(.failure(error))
            }
        }.resume()
    }
    */
}
