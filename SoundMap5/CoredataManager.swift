//
//  CoredataManager.swift
//  SoundMap5
//
//  Created by Jared Williams on 10/15/17.
//  Copyright © 2017 Jared Williams. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoredataManager {
    
    static var sharedInstance = CoredataManager()
    var objectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var settings: [Setting] = []
    var records: [Record]!
    
    func updateSetting(code: String, device: String) {
        var setting = Setting(context: objectContext)
        
        print(self.settings.count)
        
        
        print("Saving new setting code: \(code) device: \(device).)")
        
        if self.settings.count == 0 {
            print("Settings is empty")
            setting = Setting(context: self.objectContext)
            setting.code = code
            setting.device = device
            setting.points = 0
          
        }
        
        else {
            print("Settings is not empty")
            setting = self.settings[0]
            setting.code = code
            setting.device = device
        }
        
        self.save()
        self.updateData()
    }
    
    func updatePoints() {
        if !self.settings.isEmpty {
            self.settings[0].points = self.settings[0].points + 1
            self.save()
        }
    }
    
    func updateData() {
            self.settings = self.fetch(request: Setting.fetchRequest()) as! [Setting]
    }
    
    
    func saveRecordData(decibel: String, lat: String, long: String, time: String) {
        let record = Record(context: self.objectContext)
        record.decibels = decibel
        record.lat = lat
        record.long = long
        record.time = time
        
        self.save()
    }
    
    func save() {
        do {
            try self.objectContext.save()
            print("Success saving setting")
        }
        
        catch {
            print("Error saving locally")
        }
    }
    
    
    func fetch(request: NSFetchRequest<NSFetchRequestResult>) -> Any?{
        var returnObject: Any?
        
        do {
            returnObject =  try self.objectContext.fetch(request)
        }
        
        catch {
            print("Error in fetch")
        }
        
        return returnObject
    }
    
    func getRecordData() -> [Record] {
        guard let records = CoredataManager.sharedInstance.fetch(request: Record.fetchRequest()) as? [Record] else {return [Record()]}
        return records
    }
    
}
