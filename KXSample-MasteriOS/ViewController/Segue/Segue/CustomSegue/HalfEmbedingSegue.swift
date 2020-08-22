//
//  HalfEmbedingSegue.swift
//  Segue
//
//  Created by Nakjin Kim on 2020/07/25.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class HalfEmbedingSegue: UIStoryboardSegue {

	// 오버라이딩 포인트는 두가지
	
	// 초기화 코드 구현
	override init(identifier: String?, source: UIViewController, destination: UIViewController) {
		super.init(identifier: identifier, source: source, destination: destination) // 상위구현을 반드시 먼저 호출하여야 한다.
	}
	
	// destination이 정상적으로 보여지게 해야 한다.
	override func perform() {
		var frame = source.view.bounds
		frame.origin.y = frame.height
		frame.size.height = frame.height / 2
		
		source.view.addSubview(destination.view)
		destination.view.frame = frame
		destination.view.alpha = 0.0
		
		source.addChildViewController(destination)
		
		frame.origin.y = source.view.bounds.height / 2
		
		UIView.animate(withDuration: 0.3) {
			self.destination.view.frame = frame
			self.destination.view.alpha = 1.0
		}
	}
}
