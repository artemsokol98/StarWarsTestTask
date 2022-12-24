//
//  NetworkManager.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 14.12.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    let apiString = "https://swapi.dev/api/films/"
    let sessionConfig = URLSessionConfiguration.default
    
    func fetchInformation<T: Decodable>(urlString: String, expectingType: T.Type, completion: @escaping (Result<Any,Error>) -> Void) {
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        guard let url = URL(string: urlString) else { return }
        
        session.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(decodedData))
                }
            } else {
                guard let error = error else { return }
                completion(.failure(error))
            }
        }.resume()
    }
}
