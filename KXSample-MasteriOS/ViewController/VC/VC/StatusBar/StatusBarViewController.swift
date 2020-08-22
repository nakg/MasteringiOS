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

class StatusBarViewController: UIViewController {
	
	var hidden = false
	override var prefersStatusBarHidden: Bool {
		return hidden
	}
	
	@IBAction func toggleVisibility(_ sender: Any) {
		hidden = !hidden // 읽기 전용이라 이렇게 해야됨
		UIView.animate(withDuration: 0.3) {
			self.setNeedsStatusBarAppearanceUpdate() // 뷰컨트롤러에서 스테이터스봐 관련 업데이트 확인하고 실행시킨다.
		}
	}
	
	//애니메이션 종류는 프리펄드 업데이트 애니메이션 을 통해~ 설정. 히든상태일 때만 결정.
	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return .slide // 슬라이드 애니메이션을 사용.
	}
	
	
	var style = UIStatusBarStyle.default
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return style
	}
	
	@IBAction func toggleStyle(_ sender: Any) {
		style = style == .default ? .lightContent : .default

		let color = style == .default ? UIColor.white : UIColor.darkGray
		UIView.animate(withDuration: 0.3) {
			self.view.backgroundColor = color
			self.setNeedsStatusBarAppearanceUpdate() // 업데이트 구현
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
	}
}



extension StatusBarViewController {
	@IBAction func unwindToHere(_ sender: UIStoryboardSegue) {
		
	}
}













