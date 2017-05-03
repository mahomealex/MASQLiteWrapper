//
//  SQOperation.swift
//  
//
//  Created by Alex on 25/04/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import SQLite


class SQOperation : NSObject {
    
    weak var db : Connection!
    
    func save(model:SQObject) {
        let schema = SQSchemaCache.objectSchema(model: model)
        var ary:[Setter] = []
        for pt in schema.properties {
            ary.append(pt.generalSetter(model: model))
        }
        do {
            let pt = schema.primaryKeyProperty()
            let filterTable = schema.table.filter(pt.filter(model: model))
            if let _ = try db.pluck(filterTable) {//exist
                _ = try db.run(filterTable.update(ary))
            } else {
                try db.run(schema.table.insert(ary))
            }
        } catch {
            print(error)
        }
    }
    
    func saveAll(models:[SQObject]) {
        guard models.count > 0 else {
            return
        }
        for model in models {
            save(model: model)
        }
    }
    
    func delete(model:SQObject) {
        let schema = SQSchemaCache.objectSchema(model: model)
        do {
            let pt = schema.primaryKeyProperty()
            let filterTable = schema.table.filter(pt.filter(model: model))
            try db.run(filterTable.delete())
        } catch {
            print(error)
        }
    }
    
    
    func queryAll(_ m:SQObject) -> [SQObject] {
        let schema =  SQSchemaCache.objectSchema(model: m)
        var items:[SQObject] = []
        do {
            let datas = try db.prepare(schema.table)
            for data in datas {
                let item = schema.objClass.init()
                for pt in schema.properties {
                    pt.convertcolumnToModel(model: item, row: data)
                }
                items.append(item)
            }
        } catch {
            print(error)
        }
        return items
    }
    
    func queryAll<T:SQObject>(_ m:T.Type) -> [T] {
        let schema = SQSchemaCache.objectSchema(m)
        var items:[T] = []
        do {
            let datas = try db.prepare(schema.table)
            for data in datas {
                let item = schema.objClass.init()
                for pt in schema.properties {
                    pt.convertcolumnToModel(model: item, row: data)
                }
                items.append(item as! T)
            }
        } catch {
            print(error)
        }
        return items
    }
    
    
    func createTable(model:SQObject) {
       let schema = SQSchemaCache.objectSchema(model: model)
        do {
            try db.run(schema.table.create(ifNotExists: true, block: { (t) in
                for pt in schema.properties {
                    pt.buildColumn(builder: t)
                }
            }))
        } catch {
            print(error)
        }
    }
    
    func crateTable<T:SQObject>(_ m:T.Type) {
        let schema = SQSchemaCache.objectSchema(m)
        do {
//            let state =
            _ = try db.run(schema.table.create(ifNotExists: true, block: { (t) in
                for pt in schema.properties {
                    pt.buildColumn(builder: t)
                }
            }))
//            print(state)
        } catch {
            print(error)
        }
    }
    
}
