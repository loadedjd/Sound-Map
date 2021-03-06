//
//  SettingsController.swift
//  SoundMap4
//
//  Created by Jared Williams on 9/12/17.
//  Copyright © 2017 Jared Williams. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    private var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.navigationItem.rightBarButtonItem = self.addButton
        
    }
    
    func setupView() {
        self.tableView.register(SettingsCell.self, forCellReuseIdentifier: "cell")
        self.view.backgroundColor = UIColor.white
        self.addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.presentNewRecordController))
        self.addButton.tintColor = UIColor.white
    }
    
    @objc func presentNewRecordController() {
        let nav = UINavigationController(rootViewController: NewRecordController())
        self.present(nav, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsCell
        
        if (indexPath.row == 1) {
            cell.setupView()
            cell.setCellText(text: "Device Settings")
            cell.setCellImage(image: #imageLiteral(resourceName: "settings"))
        }
            
        else {
            cell.setupView()
            cell.setCellText(text: "Me")
            cell.setCellImage(image: #imageLiteral(resourceName: "person"))
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            let nav = UINavigationController(rootViewController: DeviceSettingsController())
            self.present(nav, animated: true, completion: nil)
        }
            
        else {
           let nav = Helper.createNavigationBar(viewContoller: PointController(), title: "Me", barColor: UIColor.red, tabBarTitle: "" )
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    
}

