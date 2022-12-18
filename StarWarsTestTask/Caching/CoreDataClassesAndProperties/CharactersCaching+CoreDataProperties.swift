//
//  CharactersCaching+CoreDataProperties.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 17.12.2022.
//
//

import Foundation
import CoreData


extension CharactersCaching {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharactersCaching> {
        return NSFetchRequest<CharactersCaching>(entityName: "CharactersCaching")
    }

    @NSManaged public var character: [String]?

}

extension CharactersCaching : Identifiable {

}
