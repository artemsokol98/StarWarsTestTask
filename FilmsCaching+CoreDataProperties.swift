//
//  FilmsCaching+CoreDataProperties.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 24.12.2022.
//
//

import Foundation
import CoreData


extension FilmsCaching {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilmsCaching> {
        return NSFetchRequest<FilmsCaching>(entityName: "FilmsCaching")
    }

    @NSManaged public var directorName: String?
    @NSManaged public var filmName: String?
    @NSManaged public var producerName: String?
    @NSManaged public var yearRelease: String?
    @NSManaged public var character: [String]?

}

extension FilmsCaching : Identifiable {

}
