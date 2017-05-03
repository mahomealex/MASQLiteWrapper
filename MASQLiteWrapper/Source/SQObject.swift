//
//  Object.swift
//
//
//  Created by alex on 25/04/2017.
//  Copyright © 2017 alex. All rights reserved.
//


import Foundation

open class SQObject : NSObject {
    
    required override public init() {
        super.init()
    }
    
    
    func generalSchema() -> SQObjectSchema {
        var properties:[SQProperty] = []
        let mm = Mirror(reflecting: self)
        
        let pk = self.primaryKey()
        let ignoreKeys = self.ignoreKeys()
        var primaryKeyIndex = 0
        
        
        for (index, p) in mm.children.enumerated() {
            let label = p.label!
            if ignoreKeys.contains(label) {
                continue
            }
            let vm = Mirror(reflecting: p.value)
            let propertyType = vm.subjectType
            var type:SQPropertyType = .String
            let typeString = "\(propertyType)"
            if typeString.contains("String") {
                if typeString.contains("Optional") {
                    type = .OptionString
                } else {
                    type = .String
                }
            } else if (typeString.contains("NSDate")) {
                fatalError("property is nsdate")
            } else if (typeString.contains("Int")) {
                type = .Int64
            } else if (typeString.contains("Bool")) {
                type = .Bool
            } else if (typeString.contains("Double") || typeString.contains("Float")) {
                type = .Double
            } else {
                fatalError("property is undefined type")
            }
            if label == pk {
                primaryKeyIndex = index
            }
            let pt = SQProperty(name: label, type: type, primary: primaryKeyIndex == index)
            properties.append(pt)
        }
        return SQObjectSchema(className: "\(mm.subjectType)", properties: properties, primaryKeyIndex:primaryKeyIndex, cl:type(of: self))
    }
    
    func primaryKey() -> String {
        return ""
    }
    
    func ignoreKeys() -> [String] {
        return []
    }
    
}
