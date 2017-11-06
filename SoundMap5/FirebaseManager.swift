//
//  FirebaseManager.swift
//  SoundMap5
//
//  Created by Jared Williams on 10/13/17.
//  Copyright © 2017 Jared Williams. All rights reserved.
//

import Foundation
import Firebase


class FirebaseManager {
    static let sharedInstance = FirebaseManager()
    private let databaseReference = Database.database().reference()
    private var loadedData: [String: Any]?
    
    
    
    
    
    func getData(path: String, completion: ((Any?) -> ())?) {
        self.databaseReference.child(path).observeSingleEvent(of: .value) { (snap: DataSnapshot) in
            print(snap.value)
            completion?(snap.value)
        }
    }
    
    func postData(path: String, data: [String: AnyObject], completion: ((Error?) -> ())? ) {
        self.databaseReference.child(path).childByAutoId().setValue(data, withCompletionBlock: {
            (error, databaseReference) in
            completion?(error)
        })
    }
}
