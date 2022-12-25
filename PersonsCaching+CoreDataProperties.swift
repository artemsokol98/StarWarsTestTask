//
//  PersonsCaching+CoreDataProperties.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 24.12.2022.
//
//

import Foundation
import CoreData


extension PersonsCaching {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonsCaching> {
        return NSFetchRequest<PersonsCaching>(entityName: "PersonsCaching")
    }

    @NSManaged public var characterApiString: String?
    @NSManaged public var namePerson: String?
    @NSManaged public var sexPerson: String?
    @NSManaged public var bornDatePerson: String?
    @NSManaged public var homeworld: String?

}

extension PersonsCaching : Identifiable {

}
