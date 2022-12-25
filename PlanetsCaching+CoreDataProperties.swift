//
//  PlanetsCaching+CoreDataProperties.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 25.12.2022.
//
//

import Foundation
import CoreData


extension PlanetsCaching {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanetsCaching> {
        return NSFetchRequest<PlanetsCaching>(entityName: "PlanetsCaching")
    }

    @NSManaged public var climate: String?
    @NSManaged public var diameter: String?
    @NSManaged public var gravitation: String?
    @NSManaged public var planetName: String?
    @NSManaged public var population: String?
    @NSManaged public var terrainType: String?
    @NSManaged public var apiString: String?

}

extension PlanetsCaching : Identifiable {

}
