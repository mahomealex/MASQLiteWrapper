//
//  ViewController.swift
//  SQLiteWrapper
//
//  Created by 林东鹏 on 02/05/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DBHelper.sharedInstance.setupDB()
        
        let model = TestModel()
        model.uid = "a"
        model.name = "name"
        model.age = 23
        
        //insert or update
        DBHelper.operation()?.save(model: model)
        
        //save array
        DBHelper.operation()?.saveAll(models: [model])
        
        //query
        var array = DBHelper.operation()?.queryAll(model)
        print(array ?? "")
        array = DBHelper.operation()?.queryAll(TestModel.self)
        print(array ?? "")
        
        //delete
        DBHelper.operation()?.delete(model: model)
        
        //delete by primarykey
        DBHelper.sharedInstance.delete(uid: "a")
        //query by primarykey
        DBHelper.sharedInstance.model(uid: "a")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

