//
//  TestModel.swift
//  SQLiteWrapper
//
//  Created by 林东鹏 on 02/05/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation


/*
    if you wanna any extension capacity, plz implement here. and realize those api in DBHelper
*/
protocol TestModelQuery {
    func model(uid:String) -> TestModel?
    func delete(uid:String)
}

class TestModel : SQObject {
    
    var uid : String = "" //privatekey, never set optional
    var name : String? = nil
    var age : Int64 = 0
    var length : Double = 1.0
    var isFriend : Bool = false
    
    var ignore: String = ""
    
    override func primaryKey() -> String {
        return "uid"
    }
    
    override func ignoreKeys() -> [String] {
        return ["ignore"]
    }

}
