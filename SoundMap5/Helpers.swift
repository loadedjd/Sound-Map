//
//  Helper.swift
//  SoundMap4
//
//  Created by Jared Williams on 9/12/17.
//  Copyright © 2017 Jared Williams. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Helper {
    
    static func isAuthenticated(localCode: String, remoteCode: String) -> Bool {
        var auth = false
        if localCode == remoteCode {
            auth = true
        }
        return auth
    }
    
    static func createNavigationBar(viewContoller: UIViewController, title: String, barColor: UIColor, tabBarTitle: String) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: viewContoller)
        nav.tabBarItem.title = tabBarTitle
        nav.navigationBar.topItem?.title = title
        nav.navigationBar.barTintColor = barColor
        
        return nav
    }
    
    static func showAlert(title: String, message: String, controller: UIViewController, completion: (() -> ())? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Got it!", style: .cancel) { (action) in
            completion?()
        }
        
        alert.addAction(okayAction)
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    static func decibelColor(decibels: Float) -> UIColor {
        var color: UIColor!
        
        if (decibels < 60.0) {
            color = UIColor.green
        }
        
        else if (decibels >= 60.0 && decibels < 80.0) {
            color = UIColor.yellow
        }
        
        else {
            color = UIColor.red
        }
        
        return color
    }
    
    static func getElement(index: Int, array: [String: Dictionary<String, String>]) -> Dictionary<String, String>? {
       var it =  array.makeIterator()
        var count = 0
        var returnDict: Dictionary<String, String>?
        while(count < index + 1) {
            if let dict = it.next() {
                if count == index {
                    returnDict = dict.value
                }
            }
            
            count+=1
        }
        return returnDict
    }
    
    static func createDictionary(decibels: String, lat: String, long: String, time: String, device: String) -> Dictionary<String, Any> {
        var dic = Dictionary<String, Any>()
        print(decibels)
        dic["Decibels"] = decibels
        dic["Lat"] = lat
        dic["Long"] = long
        dic["time"] = time
        dic["Device"] = device
        print(dic)
        
        return dic
    }
    
    static func timeStamp() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return formatter.string(from: now)
    }
    
    static func timeSince(date: Date) -> Double {
        let now = Date()
        print(now.timeIntervalSince(date) / 3600)
        return now.timeIntervalSince(date) / 3600
    }
    
    static func distanceBetween(localCoordinate: CLLocationCoordinate2D, remoteCoordinate: CLLocationCoordinate2D) -> Double {
        let localLocation = CLLocation(latitude: localCoordinate.latitude, longitude: localCoordinate.longitude)
        let remoteLocation  = CLLocation(latitude: remoteCoordinate.latitude, longitude: remoteCoordinate.longitude)
        print(localLocation.distance(from: remoteLocation) as Double)
        return localLocation.distance(from: remoteLocation) as Double
    }
    
    static func createCoordinate(lat: String, long: String) -> CLLocationCoordinate2D {
        let latDouble = Double(lat)
        let longDouble = Double(long)!
        let locationDegrees = CLLocationCoordinate2D(latitude: latDouble!, longitude: longDouble)
        return locationDegrees
    }
    
    static func canUpload() -> Bool {
        let localSettings = CoredataManager.sharedInstance.fetch(request: Setting.fetchRequest()) as! [Setting]
        let setting = localSettings[0]
        
        var upload = true
        FirebaseManager.sharedInstance.getData(path: "CODE") { (code: Any?) in
            if Helper.isAuthenticated(localCode: code as! String, remoteCode: setting.code!) {
                FirebaseManager.sharedInstance.getData(path: "iOS", completion: { (data: Any) in
                    let records = data as! [String: Dictionary<String, String>]
                    let localCoordinate = CLLocationCoordinate2D(latitude: (LocationManager.sharedInstance.currentLocation?.coordinate.latitude)!, longitude: (LocationManager.sharedInstance.currentLocation?.coordinate.longitude)!)
                    
                    for dictionary: Dictionary<String, String> in records.values {
                        
                        
                        let remoteLat = dictionary["Lat"]!
                        let remoteLong = dictionary["Long"]
                        
                        let remoteCoordinate = Helper.createCoordinate(lat: remoteLat, long: remoteLong!)
                        
                        let remoteFormatter = DateFormatter()
                        remoteFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        let remoteTime = remoteFormatter.date(from: dictionary["time"]!)
                        print(dictionary["time"])
                        
                        if (Helper.distanceBetween(localCoordinate: localCoordinate, remoteCoordinate: remoteCoordinate) < 500) && Helper.timeSince(date: remoteTime!) < 1 {
                            upload = false
                        }
                        
                        
                    }
                })
            }
        }
        return upload
    }
    
}

extension String {
    func truncate(length: Int) -> String {
        return String(self.characters.prefix(length))
    }

}





