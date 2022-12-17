//
//  PersonsCaching+CoreDataProperties.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 17.12.2022.
//
//

import Foundation
import CoreData


extension PersonsCaching {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonsCaching> {
        return NSFetchRequest<PersonsCaching>(entityName: "PersonsCaching")
    }

    @NSManaged public var bornDatePerson: String?
    @NSManaged public var homeworld: String?
    @NSManaged public var namePerson: String?
    @NSManaged public var sexPerson: String?

}

extension PersonsCaching : Identifiable {

}
