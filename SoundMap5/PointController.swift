//
//  PointController.swift
//  SoundMap4
//
//  Created by Jared Williams on 9/18/17.
//  Copyright © 2017 Jared Williams. All rights reserved.
//

import UIKit

class PointController: UIViewController {
    
    private var doneBarButton: UIBarButtonItem!
    private var pointsLabel: UILabel!
    private var orgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        
    }
    
    func setupView() {
        self.navigationController?.navigationBar.topItem?.title = "Me"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.view.backgroundColor = UIColor.white
        
        self.doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonPressed))
        self.doneBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        self.pointsLabel = UILabel()
        self.orgLabel = UILabel()
        
        
        let localSettings = CoredataManager.sharedInstance.fetch(request: Setting.fetchRequest()) as! [Setting]
        let setting = localSettings[0]
        
        FirebaseManager.sharedInstance.getData(path: "CODE") { (code: Any?) in
            let remoteCode = code as! String
            
            
            if Helper.isAuthenticated(localCode: setting.code!, remoteCode: remoteCode) {
                self.pointsLabel.text = "\(setting.points) Points"

                FirebaseManager.sharedInstance.getData(path: "ORG") { (org: Any?) in
                    self.orgLabel.text = "Authenticated with: \(org as! String) "
                }
            }
            
            else {
                Helper.showAlert(title: "You dont have an Org connected!", message: "Connect to an orginzation to start racking up points!", controller: self, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
            
        }
        
        self.pointsLabel.font = UIFont.systemFont(ofSize: 50)
        self.pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.pointsLabel)
        
        self.orgLabel.font = UIFont.systemFont(ofSize: 25)
        self.orgLabel.translatesAutoresizingMaskIntoConstraints = false
        self.orgLabel.textColor = UIColor.lightGray
        self.view.addSubview(self.orgLabel)
        
        
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.pointsLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.pointsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.orgLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        self.orgLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

