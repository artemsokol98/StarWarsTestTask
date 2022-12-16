//
//  PlanetViewModel.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 16.12.2022.
//

import Foundation

protocol PlanetViewModelProtocol: AnyObject {
    var planetModelForView: PlanetModelForView! { get set }
    func downloadingPlanet(apiString: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class PlanetViewModel: PlanetViewModelProtocol {
    var planetModelForView: PlanetModelForView!
    
    func downloadingPlanet(apiString: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.fetchPlanet(planetApiString: apiString) { result in
            switch result {
            case .success(let planet):
                DispatchQueue.main.async {
                    self.planetModelForView = self.parsePlanet(planet: planet)
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
    
    func parsePlanet(planet: Planet) -> PlanetModelForView {
        return PlanetModelForView(
            planetName: planet.name,
            diameter: planet.diameter,
            climate: planet.climate,
            gravitation: planet.gravity,
            terrainType: planet.terrain,
            population: planet.population
        )
    }
    
    
}
