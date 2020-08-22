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

class SecondToolbarViewController: UIViewController {
	
	@IBAction func toggleToolbar(_ sender: Any) {
		let hidden = navigationController?.isToolbarHidden ?? false // 현재 툴바 히든여부.
		navigationController?.setToolbarHidden(!hidden, animated: true) // 현재 툴바 토글. 애니메이션.
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //단순 배치 용도
		let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
		let trashItem = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: nil)
		
		// 툴바 셋팅.
		setToolbarItems([flexibleSpaceItem, addItem, flexibleSpaceItem, trashItem, flexibleSpaceItem], animated: true)
	}
}



























