//
//  RecordController.swift
//  SoundMap5
//
//  Created by Jared Williams on 10/13/17.
//  Copyright © 2017 Jared Williams. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "CELL"


class RecordController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var hasInitiated: Bool = false
    private var addButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    func setupView() {
        self.collectionView!.register(RecordCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        
        self.addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonPressed))
        self.addButton.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = self.addButton
    }
    
   @objc func reloadData() {
    self.hasInitiated = true
    self.collectionView?.reloadData()
    }
    
    @objc func addButtonPressed() {
        let nav = Helper.createNavigationBar(viewContoller: NewRecordController(), title: "New Record", barColor: UIColor.red, tabBarTitle: "")
        self.present(nav, animated: true, completion: nil)
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoredataManager.sharedInstance.getRecordData().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecordCell
        let record = CoredataManager.sharedInstance.getRecordData()[indexPath.row]
        
        
        cell.setDecibel(text: record.decibels!)
        cell.setTimeLabel(text: record.time!)
        cell.setColorView(color: Helper.decibelColor(decibels: Float(record.decibels!)!))
        cell.setLocationLabel(text: "\(record.lat!.truncate(length: 5)) N \(record.long!.truncate(length: 5)) W")
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 100)
    }
}
