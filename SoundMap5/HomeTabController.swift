//
//  HomeTabController.swift
//  SoundMap5
//
//  Created by Jared Williams on 10/13/17.
//  Copyright © 2017 Jared Williams. All rights reserved.
//

import UIKit

class HomeTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setupView() {
        self.tabBar.tintColor = UIColor.red

        self.setupViewControllers()
    }
    
    func setupViewControllers() {
        
        let recordController = RecordController(collectionViewLayout: UICollectionViewFlowLayout())
        let recordNav = Helper.createNavigationBar(viewContoller: recordController, title: "My Records", barColor: UIColor.red, tabBarTitle: "Records")
        recordNav.tabBarItem.image = #imageLiteral(resourceName: "recordsSymbol")
        
        let settingsNav = Helper.createNavigationBar(viewContoller: SettingsController(), title: "Settings", barColor: UIColor.red, tabBarTitle: "Settings")
        settingsNav.tabBarItem.image = #imageLiteral(resourceName: "if_settings_115801")
        
        let mapNav = Helper.createNavigationBar(viewContoller: MapViewController(), title: "Map", barColor: .red, tabBarTitle: "Map")
        mapNav.tabBarItem.image = #imageLiteral(resourceName: "locationSymbol")
        
        self.viewControllers = [recordNav, mapNav, settingsNav]

    }
}
