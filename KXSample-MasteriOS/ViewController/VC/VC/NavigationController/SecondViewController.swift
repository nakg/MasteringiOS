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

class SecondViewController: UIViewController {
	
	@IBAction func pop(_ sender: Any) {
		// 스택에서 하나 팝시킬때.
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func pushThird(_ sender: Any) {
		guard let thirdVC = storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") else {return}
		
		navigationController?.pushViewController(thirdVC, animated: true)
	}
	
	@objc func addRightButtons() {
		let btn1 = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
		let btn2 = UIBarButtonItem(title: "Two", style: .plain, target: nil, action: nil)
		
		// 무언가를 네비게이션 바에 넣을 때에는, barItem 에 추가하고, 넣어야 한다.
		let sw = UISwitch()
		let switchItem = UIBarButtonItem(customView: sw)
		navigationItem.setRightBarButtonItems([switchItem, btn1, btn2], animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// back 버튼이 다른버튼과 함께 노출되도록.
		navigationItem.leftItemsSupplementBackButton = true
		// 좌측 아이템에 add버튼하나 추가하고, add버튼 메서드 구현.
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRightButtons))
		
	}
}


























