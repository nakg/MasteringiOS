//
//  HalfEmbedingUnwindSegue.swift
//  Segue
//
//  Created by Nakjin Kim on 2020/07/25.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class HalfEmbedingUnwindSegue: UIStoryboardSegue {

	override func perform() {
		var frame = source.view.frame
		frame = frame.offsetBy(dx: 0, dy: frame.height)
		
		UIView.animate(withDuration: 0.3, animations: {
			self.source.view.frame = frame
			self.source.view.alpha = 0.0
		}) { (finished) in
			self.source.view.removeFromSuperview()
			self.source.removeFromParentViewController()
		}
	}
}
