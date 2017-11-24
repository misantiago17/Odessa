//
//  CoreData.swift
//  Odessa
//
//  Created by Mariela Andrade on 23/11/2017.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import CoreData

class CoreData: NSManagedObject {

    
    
//     func sceneDidLoad() {
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        storeData(context: context, moeda: 20)
//    }
    
    func storeData(context: NSManagedObjectContext, moeda: Int){
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        newUser.setValue("moeda", forKey: "coins")
      //  newUser.setValue("123", forKey: "password")
        do {
            try context.save()
            print("SAVED")
        }
        catch{
            print("erro")
        }
        
    }
    
    func reccoverData (context: NSManagedObjectContext, moeda: Int){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let moeda = result.value(forKey: "coins") as? Int {
                        print(moeda)
                    }
//                    if let password = result.value(forKey: "password") as? String {
//                         print(password)
//                    }
                }
            }
        }
        catch {
            print("erro")
        }
    }
        
    
    
   
  
    


    
    
    
    
}
