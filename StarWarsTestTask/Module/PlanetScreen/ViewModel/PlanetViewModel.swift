//
//  PlanetViewModel.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 16.12.2022.
//

import Foundation
import UIKit

protocol PlanetViewModelProtocol: AnyObject {
    var planetModelForView: PlanetModelForView! { get set }
    func downloadingPlanet(apiString: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class PlanetViewModel: PlanetViewModelProtocol {
    var planetModelForView: PlanetModelForView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func downloadingPlanet(apiString: String, completion: @escaping (Result<Void, Error>) -> Void) {
        /*
        if let data = UserDefaults.standard.data(forKey: apiString) {
            do {
                let tvm = try JSONDecoder().decode(PlanetModelForView.self, from: data)
                self.planetModelForView = tvm
                completion(.success(()))
            } catch {
                
            }
        } else {
            */
        
        do {
            let result = try? DataManager.shared.searchPlanetInDataBase(entity: "PlanetCaching", apiString: apiString)
            guard let result = result else { throw CoreDataErrors.CouldntGetData }
            planetModelForView = result
            completion(.success(()))
        } catch {
            NetworkManager.shared.fetchInformation(urlString: apiString, expectingType: Planet.self) { result in
            switch result {
            case .success(let planet):
                guard let planet = planet as? Planet else { return }
                DispatchQueue.main.async {
                    self.planetModelForView = self.parsePlanet(planet: planet)
                    self.createNewItem(planet: self.planetModelForView, apiString: apiString)
                    /*
                    do {
                        let data = try JSONEncoder().encode(self.planetModelForView)
                        UserDefaults.standard.set(data, forKey: apiString)
                    } catch {
                        
                    }
                     */
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
    
    func createNewItem(planet: PlanetModelForView, apiString: String) {
        let newItem = PlanetsCaching(context: context)
        newItem.apiString = apiString
        newItem.planetName = planet.planetName
        newItem.population = planet.population
        newItem.terrainType = planet.terrainType
        newItem.gravitation = planet.gravitation
        newItem.climate = planet.climate
        newItem.diameter = planet.diameter
    }
}
