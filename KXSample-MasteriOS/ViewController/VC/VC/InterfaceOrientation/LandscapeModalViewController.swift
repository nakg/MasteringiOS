//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import AVFoundation

class LandscapeModalViewController: UIViewController {
	
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var playerView: PlayerView!
	
	// 처음 뷰컨트롤러 진입시, orientation 결정. 나머진 회전으로 바꿀 수도 있음. 초기 설정만 결정.
	override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
		return .landscapeLeft
	}
	
	// 새로운 trait collection이 실제로 적용되기 전에 호출. trait collection에 포함된 vertical 사이즈를 통해서, 가로 세로를 대략 파악할 수 있다. 단, 아이패드에서 풀로하면 적용이 안된다. 아래가 더 정확한 방법이다.
	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		super.willTransition(to: newCollection, with: coordinator)
		
		print(newCollection.verticalSizeClass.description)
		
		// sizeclass에 따른, 버튼 색깔 생성.
		switch newCollection.verticalSizeClass {
		case .regular:
			closeButton.backgroundColor = UIColor.red.withAlphaComponent(0.5)
		default:
			closeButton.backgroundColor = UIColor.green.withAlphaComponent(0.5)
		}
	}
	
	// 루트뷰의 사이즈가 업데이트되기전에 호출. 첫번째 파라미터로 새로운 사이즈가 전달된다. 이 값을 통해 가로모드 세로모드의 정확한 파악이 가능하다. 단, 전환될 때 호출되므로 처음 뷰디드로드때는 초기화를 넣어줘야 할듯? 첫셋팅만.coordinator는 애니메이션 적용할 때 활용.
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		// animation
		coordinator.animate(alongsideTransition: { (context) in
			if size.height > size.width {
				self.closeButton.backgroundColor = UIColor.red.withAlphaComponent(0.5)
			}
			else {
				self.closeButton.backgroundColor = UIColor.green.withAlphaComponent(0.5)
			}
		}, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let url = Bundle.main.url(forResource: "video", withExtension: "mp4") else { return }
		let player = AVPlayer(url: url)
		playerView.player = player
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		playerView.player?.play()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		playerView.player?.pause()
	}
	
	
}



extension UIUserInterfaceSizeClass {
	var description: String {
		switch self {
		case .compact:
			return "Compact"
		case .regular:
			return "Regular"
		default:
			return "Unspecified"
		}
	}
}
















