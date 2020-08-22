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

class TextSelectionViewController: UIViewController {
	
	@IBOutlet weak var textView: UITextView!
	
	@IBAction func selectLast(_ sender: Any) {
		let lastWord = "pariatur?"
		
		if let text = textView.text as NSString? {
			let range = text.range(of: lastWord)
			textView.selectedRange = range
			
			// 선택된 범위로 스크롤
			textView.scrollRangeToVisible(range)
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
}

extension TextSelectionViewController: UITextViewDelegate {
	// 특정범위 셀렉 할때마다 호출. 셀렉 범위도 사용할 수 있다.
	func textViewDidChangeSelection(_ textView: UITextView) {
		let range = textView.selectedRange
		print(range)
	}
}
