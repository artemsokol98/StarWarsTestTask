//
//  StringArrayTransformer.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 17.12.2022.
//

import Foundation

class StringArrayTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let stringArray = value as? [String] else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: stringArray, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let arrayString = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: NSString.self, from: data)
            var convertedArrayString = [String]()
            guard let unwrapedArray = arrayString else { return nil }
            for item in unwrapedArray {
                let convert = String(item)
                convertedArrayString.append(convert)
            }
            return convertedArrayString
        } catch {
            return nil
        }
    }
}
