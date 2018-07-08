//
//  TabViewController.swift
//  macconnect
//
//  Created by Philipp Matthes on 06.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation

import UIKit
import Material

class TabsViewController: TabsController {
    open override func prepare() {
        super.prepare()
        tabBar.lineColor = UIColor(rgb: 0x7CD201, alpha: 1.0)
//        tabBar.setLineColor(Color.orange.base, for: .selected) // or tabBar.lineColor = Color.orange.base
//
//        tabBar.setTabItemsColor(Color.grey.base, for: .normal)
//        tabBar.setTabItemsColor(Color.purple.base, for: .selected)
//        tabBar.setTabItemsColor(Color.green.base, for: .highlighted)
//
//        tabBar.
        
//        tabBar.tabItems.first?.setTabItemColor(Color.blue.base, for: .selected)
        //    let color = tabBar.tabItems.first?.getTabItemColor(for: .selected)
        
        tabBarAlignment = .bottom
        tabBar.tabBarStyle = .auto
        tabBar.dividerColor = nil
        tabBar.lineHeight = 5.0
        tabBar.lineAlignment = .bottom
    }
}
