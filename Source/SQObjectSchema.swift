//
//  SQObjectSchema.swift
//  FaceU
//
//  Created by Alex on 25/04/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import SQLite

final class SQObjectSchema : NSObject {
    
    public var properties : [SQProperty]
    public var className : String
    private let primaryKeyIndex : Int
    public let table : Table
    public let objClass : SQObject.Type
    
    init(className:String, properties:[SQProperty], primaryKeyIndex:NSInteger, cl:SQObject.Type) {
        self.properties = properties
        self.className = className
        self.primaryKeyIndex = primaryKeyIndex
        self.table = Table(className)
        self.objClass = cl
    }
    
    func primaryKeyProperty() -> SQProperty {
        return properties[primaryKeyIndex]
    }
    
}
