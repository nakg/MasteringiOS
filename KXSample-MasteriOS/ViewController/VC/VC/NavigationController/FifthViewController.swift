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

class FifthViewController: UIViewController {
	
	@IBAction func popToRoot(_ sender: Any) {
		// popTorootview method
		navigationController?.popToRootViewController(animated: true)
	}
	
	@IBAction func popToThird(_ sender: Any) {
		
		// 네비게이션 스택내의 뷰컨트롤러에 접근하기. viewcontrollers로 배열 접근 가능.
		guard let thirdVC = navigationController?.viewControllers.first(where: { $0 is ThirdViewController
		}) else {return}
		
		navigationController?.popToViewController(thirdVC, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Fifth"
		
	}
}


























