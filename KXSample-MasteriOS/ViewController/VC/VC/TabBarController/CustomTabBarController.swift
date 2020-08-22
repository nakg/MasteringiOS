//
//  CustomTabBarController.swift
//  VC
//
//  Created by Nakjin Kim on 2020/07/19.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		

		delegate = self
	}
	
}

extension CustomTabBarController: UITabBarControllerDelegate {
	// tabbar를 탭할 때 호출. 트루를 리턴하면 선택되고, 아니면 선택이 안된다.
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		if let secondVC = tabBarController.viewControllers?[1] {
			return viewController != secondVC
		}
		
		return true
	}
	
//	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//		<#code#>
//	}
}
