//
//  PersonsArrayTransformer.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 17.12.2022.
//

import Foundation

class PersonsArrayTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let personsArray = value as? [PersonTableViewCellModel] else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: personsArray, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            guard let personsArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [PersonTableViewCellModel] else { return nil }
            /*
            var convertedArrayString = [String]()
            //guard let unwrapedArray = arrayString else { return nil }
            for item in unwrapedArray {
                let convert = String(item)
                convertedArrayString.append(convert)
            }
             */
            return personsArray
        } catch {
            return nil
        }
    }
}
