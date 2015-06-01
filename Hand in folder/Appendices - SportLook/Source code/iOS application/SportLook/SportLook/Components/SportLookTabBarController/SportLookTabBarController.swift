//
//  SportLookTabBarController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 06/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class SportLookTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor.COLOR_BLUE_DARK
        self.tabBar.barTintColor = UIColor.COLOR_NAVBAR_BACKGROUND
//        self.tabBar.backgroundColor = UIColor.whiteColor()
        
        let searchEventController = SearchEventsViewController()
        let searchEventTab = UINavigationController(rootViewController: searchEventController)
        searchEventTab.tabBarItem.title = "Find Event"
        searchEventTab.tabBarItem.image = UIImage(named: "TabSearch")
//        searchEventController.tabBarItem.selectedImage = UIImage(named: "TabSearchSelected")

        let myEventsController = MyEventsViewController()
        let myEventsTab = UINavigationController(rootViewController: myEventsController)
        myEventsTab.tabBarItem.title = "My Events"
        myEventsTab.tabBarItem.image = UIImage(named: "TabEvents")
        myEventsTab.tabBarItem.selectedImage = UIImage(named: "TabEvents")
        
        let discoverController = DiscoverViewController()
        let discoverTab = UINavigationController(rootViewController: discoverController)
        discoverTab.tabBarItem.title = "Discover"
        discoverTab.tabBarItem.image = UIImage(named: "TabDiscover")
        discoverTab.tabBarItem.selectedImage = UIImage(named: "TabDiscoverSelected")
        
        let profileController = ProfileViewController()
        let profileTab = UINavigationController(rootViewController: profileController)
        profileTab.tabBarItem.title = "Profile"
        profileTab.tabBarItem.image = UIImage(named: "TabProfile")
        profileTab.tabBarItem.selectedImage = UIImage(named: "TabProfileSelected")
        
        self.viewControllers = [searchEventTab, myEventsTab, discoverTab, profileTab]
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
