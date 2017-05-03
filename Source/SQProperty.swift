//
//  SQProperty.swift
//  
//
//  Created by Alex on 25/04/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import SQLite


enum SQPropertyType : Int {
    case String = 0, OptionString, Int64, Double, Bool
}

public final class SQProperty : NSObject {
    let name:String
    let type:SQPropertyType
    let primary:Bool
    private let _express:Expressible
    
    
    init(name:String , type:SQPropertyType, primary:Bool = false) {
        self.name = name
        self.type = type
        self.primary = primary
        
        switch self.type {
        case .String:
            self._express =  Expression<String>(name)
        case .OptionString:
            self._express = Expression<String?>(name)
        case .Int64:
            self._express = Expression<Int64>(name)
        case .Bool:
            self._express = Expression<Bool>(name)
        case .Double:
            self._express = Expression<Double>(name)
        }
        
    }
    
    //    var express : Expressible {
    ////        return self._express
    //        switch type {
    //        case .String:
    //            return  optional ? _express as! Expression<String?> : _express as! Expression<String> //  Expression<String?>(name) : Expression<String>(name)
    //        case .Int64:
    //            return optional ? Expression<Int64?>(name) : Expression<Int64>(name)
    //        case .Bool:
    //            return optional ? Expression<Bool?>(name) : Expression<Bool>(name)
    //        case .Double:
    //            return optional ? Expression<Double?>(name) : Expression<Double>(name)
    //        }
    //    }
    
    public func generalSetter(model:SQObject) -> SQLite.Setter {
        switch type {
        case .String:
            return _express as! Expression<String> <- model.value(forKey: name) as! String
        case .OptionString:
            return _express as! Expression<String?> <- model.value(forKey: name) as? String
        case .Int64:
            return _express as! Expression<Int64> <- model.value(forKey: name) as! Int64
        case .Bool:
            return _express as! Expression<Bool> <- model.value(forKey: name) as! Bool
        case .Double:
            return _express as! Expression<Double> <- model.value(forKey: name) as! Double
        }
        
    }
    
    public func convertcolumnToModel(model:SQObject, row:Row) {
        switch type {
        case .String:
            model.setValue(row[_express as! Expression<String>], forKey: name)
        case .OptionString:
            model.setValue(row[_express as! Expression<String?>], forKey: name)
        case .Int64:
            model.setValue(row[_express as! Expression<Int64>], forKey: name)
        case .Bool:
            model.setValue(row[_express as! Expression<Bool>], forKey: name)
        case .Double:
            model.setValue(row[_express as! Expression<Double>], forKey: name)
        }
    }
    
    public func filter(model:SQObject) -> Expression<Bool> {
        switch type {
        case .String:
            return (_express as! Expression<String> == model.value(forKey: name) as! String)
        case .OptionString:
            return (_express as! Expression<String> == (model.value(forKey: name) as? String)!)
        case .Int64:
            return (_express as! Expression<Int64> == model.value(forKey: name) as! Int64)
        case .Bool:
            return (_express as! Expression<Bool> == model.value(forKey: name) as! Bool)
        case .Double:
            return (_express as! Expression<Double> == model.value(forKey: name) as! Double)
        }
    }
    
    //    public func filterOptional(model:SQObject) -> Expression<Bool?> {
    //        switch type {
    //        case .String:
    //            return (_express as! Expression<String?> == model.value(forKey: name) as? String)
    //        case .Int64:
    //            return (_express as! Expression<Int64> == model.value(forKey: name) as! Int64)
    //        case .Bool:
    //            return (_express as! Expression<Bool> == model.value(forKey: name) as! Bool)
    //        case .Double:
    //            return (_express as! Expression<Double> == model.value(forKey: name) as! Double)
    //        }
    //    }
    
    public func buildColumn(builder:SQLite.TableBuilder) {
        switch type {
        case .String:
            if primary {
                builder.column(_express as! Expression<String>, primaryKey: true)
            } else {
                builder.column(_express as! Expression<String>, defaultValue: "")
            }
        case .OptionString:
            builder.column(_express as! Expression<String?>, defaultValue: "")
        case .Int64:
            if primary {
                builder.column(_express as! Expression<Int64>, primaryKey: true)
            } else {
                builder.column(_express as! Expression<Int64>, defaultValue: 0)
            }
        case .Bool:
            if primary {
                builder.column(_express as! Expression<Bool>, primaryKey: true)
            } else {
                builder.column(_express as! Expression<Bool>, defaultValue: false)
            }
        case .Double:
            if primary {
                builder.column(_express as! Expression<Double>, primaryKey: true)
            } else {
                builder.column(_express as! Expression<Double>, defaultValue: 0)
            }
        }
    }
    
}

