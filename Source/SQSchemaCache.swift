//
//  SQSchemaCache.swift
//
//
//  Created by Alex on 28/04/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation


class SQSchemaCache : NSObject {
    
    static var cache:[String : SQObjectSchema] = [:]
    
    static func objectSchema(model:SQObject) -> SQObjectSchema {
        let name = NSStringFromClass(type(of: model))
        if let obj = cache[name] {
            return obj
        }
        let schema = model.generalSchema()
        cache[name] = schema
        return schema
    }
    
    static func objectSchema<T:SQObject>(_ m:T.Type) -> SQObjectSchema {
        let name = NSStringFromClass(m)
        if let obj = cache[name] {
            return obj
        }
        let model = m.init()
        let schema = model.generalSchema()
        cache[name] = schema
        return schema
    }

}
