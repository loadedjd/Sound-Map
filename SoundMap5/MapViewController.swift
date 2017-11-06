//
//  MapController.swift
//  SoundMap4
//
//  Created by Jared Williams on 9/12/17.
//  Copyright © 2017 Jared Williams. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    private var mapView: MKMapView!
    private var addButton: UIBarButtonItem!
    private var addedAnnotations: [MKPointAnnotation]!
    private var centerButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.addButton
        
        self.setupMapView()
        self.setupView()
        self.setupConstraints()
        self.addAnnotations()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addAnnotations), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.mapView.removeAnnotations(self.addedAnnotations)
        self.addAnnotations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        self.addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.presentNewRecordController))
        self.addButton.tintColor = UIColor.white
        self.centerButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.centerButtonWasPushed))
        self.centerButton.tintColor = UIColor.white
        self.addedAnnotations = [MKPointAnnotation]()
        
        self.navigationItem.leftBarButtonItem = self.centerButton
        self.navigationItem.rightBarButtonItem = self.addButton
        
        self.view.addSubview(self.mapView)
    }
    
    func setupMapView() {
        self.mapView = MKMapView(frame: self.view.frame)
        self.setMapCenter(longitude: -82.9988889 , latitude: 39.9611111)
        self.mapView.showsUserLocation = true
    }
    
    func setupConstraints() {
        self.mapView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.mapView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    func makeRegion(center: CLLocationCoordinate2D) -> MKCoordinateRegion{
        
        let region = MKCoordinateRegionMakeWithDistance(center, 30000, 30000)
        return region
    }
    
    func setMapCenter(longitude: Double, latitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.mapView.setRegion(makeRegion(center: coordinate), animated: true)
        
    }
    
    @objc func centerButtonWasPushed() {
        self.setMapCenter(longitude: -82.9988889 , latitude: 39.9611111)
    }
    
    @objc func addAnnotations() {
        let localSettings = CoredataManager.sharedInstance.fetch(request: Setting.fetchRequest()) as! [Setting]
        let setting = localSettings[0]
        
        FirebaseManager.sharedInstance.getData(path: "CODE") { (code: Any?) in
            if Helper.isAuthenticated(localCode: code as! String, remoteCode: setting.code!) {
                FirebaseManager.sharedInstance.getData(path: "iOS", completion: { (data: Any) in
                    let records = data as! [String: Dictionary<String, String>]
                    
                    for dictionary: Dictionary<String, String> in records.values {
                        let annotation = MKPointAnnotation()
                        var coordinate = CLLocationCoordinate2D()
                        coordinate.latitude = Double(dictionary["Lat"]!)!
                        coordinate.longitude = Double(dictionary["Long"]!)!
                        
                        annotation.coordinate = coordinate
                        annotation.subtitle = "Recorded on \(dictionary["time"] ?? "")"
                        
                        self.mapView.addAnnotation(annotation)
                        self.addedAnnotations.append(annotation)
                    }
                    
                    
                })
            }
            
            else {
                let data = CoredataManager.sharedInstance.getRecordData()
                
                for record in data {
                    let annotation = MKPointAnnotation()
                    var coordinate = CLLocationCoordinate2D()
                    
                    coordinate.latitude = Double(record.lat!) ?? 0.0
                    coordinate.longitude = Double(record.long!) ?? 0.0
                    
                    annotation.coordinate = coordinate
                    annotation.subtitle = "Recorded on \(record.time ?? "")"
                    
                    self.mapView.addAnnotation(annotation)
                    self.addedAnnotations.append(annotation)
                }
            }
        }
    }
    @objc func presentNewRecordController() {
        let nav = UINavigationController(rootViewController: NewRecordController())
        self.present(nav, animated: true, completion: nil)
    }
    
}

