//
//  DBHelper.swift
//  SQLiteWrapper
//
//  Created by Alex on 02/05/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import SQLite

class DBHelper {
    
    static let sharedInstance = DBHelper()
    
    fileprivate var _db : Connection!
    fileprivate var _operation : SQOperation?
    
    
    private func dbPath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return "\(path)/db.sqlite3"
    }
    
    class func operation() -> SQOperation? {
        return sharedInstance._operation
    }
    
    public func setupDB() {
        do {
            let dbPath = self.dbPath()
            print("setup db: \(dbPath)")
            _db = try Connection(dbPath)
        } catch {
            print("create db fail: %@", error)
            return
        }
        _operation = SQOperation()
        _operation!.db = _db
        //init model here
        _operation!.crateTable(TestModel.self)

    }
}

//some extension query for each model.
extension DBHelper : TestModelQuery {
    func model(uid: String) -> TestModel? {
        let model = TestModel()
        model.uid = uid
        let schema = SQSchemaCache.objectSchema(TestModel.self)
        let pt = schema.primaryKeyProperty()
        let filterTable = schema.table.filter(pt.filter(model: model))
        do {
            let array = try _db.prepare(filterTable)
            for row in array {
                for property in schema.properties {
                    property.convertcolumnToModel(model: model, row: row)
                }
                return model
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func delete(uid: String) {
        let model = TestModel()
        model.uid = uid
        _operation?.delete(model: model)
    }
}
