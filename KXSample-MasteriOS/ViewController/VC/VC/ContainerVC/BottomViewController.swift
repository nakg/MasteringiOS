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

class BottomViewController: UIViewController {
	
	@IBAction func removeFromParent(_ sender: Any) {
		/*
		컨테이너뷰에서 차일드뷰 제거하는 순서
		1. 루트뷰를 뷰계층에서 제거.
		2. 컨테이너 클래스에서 제거.
		*/
		
		view.removeFromSuperview()
		removeFromParentViewController()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	// 컨테이너에 추가되거나 삭제되기 직전 호출. 추가될 때는 컨테이너뷰컨트롤러가 파라미터로오고, 삭제될땐 nil이 온다.
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
		print(String(describing: type(of: self)), #function, parent?.description ?? "nil")
	}
	
	// 컨테이너에 추가되거나 삭제된 직후
	override func didMove(toParentViewController parent: UIViewController?) {
		super.didMove(toParentViewController: parent)
		print(String(describing: type(of: self)), #function, parent?.description ?? "nil")
	}
	
}













