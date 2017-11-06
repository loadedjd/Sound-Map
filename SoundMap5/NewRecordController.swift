//
//  NewRecordController.swift
//  SoundMap5
//
//  Created by Jared Williams on 10/15/17.
//  Copyright © 2017 Jared Williams. All rights reserved.
//

import UIKit

class NewRecordController: UIViewController {

    private var decibelLabel: UILabel = {
       let label = UILabel()
        label.text = " :dB"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 50)
        return label
    }()
    
    private lazy var doneBarButton: UIBarButtonItem = {
       let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonPressed))
        button.tintColor = UIColor.white
        return button
        
    }()
    
    private lazy var recordButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "Rectangle"), for: .normal)
        button.setTitle("Record", for: .normal)
        button.addTarget(self, action: #selector(self.recordButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var audioManager: AudioManager = {
        let audio = AudioManager()
        return audio
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setConstraints()
        self.setupNavBar()
        self.setupNotifications()
    }
    
    func setupView() {
    
        self.view.addSubview(self.decibelLabel)
        self.view.addSubview(self.recordButton)
    }
    
    func setupNavBar() {
        
        self.navigationItem.rightBarButtonItem = self.doneBarButton
        self.navigationController?.navigationBar.topItem?.title = "New Record"
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        self.view.backgroundColor = UIColor.white
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateView), name: NSNotification.Name(rawValue: "updateAudio"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.recordingDone), name: NSNotification.Name(rawValue: "recordingDone"), object: nil)
    }
    
    func setConstraints() {
        self.recordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.recordButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.decibelLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.decibelLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func recordButtonPressed() {
        self.doneBarButton.isEnabled = false
        self.recordButton.isEnabled = false
        self.audioManager.startRecording()
    }
    
    
    @objc func updateView() {
        guard let sample = self.audioManager.samples.last else { return }
        var color: UIColor
        
    
        if (Double(sample) < 60) {
            color = UIColor.green
        }
            
        else if (Double(sample) >= 60 && Double(sample) < 80 ) {
            color = UIColor.yellow
        }
            
        else {
            color = UIColor.red
        }
        
        self.decibelLabel.textColor = color
        self.decibelLabel.text = "\(sample) dB"
    }
    
    @objc func recordingDone() {
        self.dismiss(animated: true, completion: nil)
        
        let localSettings = CoredataManager.sharedInstance.fetch(request: Setting.fetchRequest()) as! [Setting]
        let setting = localSettings[0]
        var localCode = ""
        var remoteCode = ""
    
        
        
        
        FirebaseManager.sharedInstance.getData(path: "CODE") { (code: Any?) in
                localCode = setting.code!
                remoteCode = code as! String
            
            
            if Helper.isAuthenticated(localCode: localCode, remoteCode: remoteCode) {
                let data = Helper.createDictionary(decibels: String(self.audioManager.logAverage!), lat: String(describing: LocationManager.sharedInstance.currentLocation!.coordinate.latitude) , long: String(describing: LocationManager.sharedInstance.currentLocation!.coordinate.longitude) , time: Helper.timeStamp(), device: setting.device!) as [String: Any]
                
                if Helper.canUpload() {
                    FirebaseManager.sharedInstance.postData(path: "iOS", data: data as [String : AnyObject], completion: nil)
                    CoredataManager.sharedInstance.updateData()
                    CoredataManager.sharedInstance.updatePoints()
                }
                
                CoredataManager.sharedInstance.saveRecordData(decibel: String(describing: self.audioManager.logAverage!).truncate(length: 5) , lat: String(describing: (LocationManager.sharedInstance.currentLocation?.coordinate.latitude)!) , long: String(describing: (LocationManager.sharedInstance.currentLocation?.coordinate.longitude)!) , time: Helper.timeStamp())
                
            }
                
            else {
                CoredataManager.sharedInstance.updateData()
                CoredataManager.sharedInstance.saveRecordData(decibel: String(describing: self.audioManager.logAverage!).truncate(length: 5) , lat: String(describing: (LocationManager.sharedInstance.currentLocation?.coordinate.latitude)!) , long: String(describing: (LocationManager.sharedInstance.currentLocation?.coordinate.longitude)!) , time: Helper.timeStamp())
                
                
                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "reloadData")))
            }
        }
    }
}

extension NewRecordController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portraitUpsideDown
    }
}

extension UINavigationController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}



