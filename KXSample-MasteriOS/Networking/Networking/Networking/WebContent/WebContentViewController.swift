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
import WebKit

class WebContentViewController: UIViewController {
	
	@IBOutlet weak var urlField: UITextField!
	@IBOutlet weak var webView: WKWebView!
	
	@IBAction func goBack(_ sender: Any) {
		// Code Input Point #3
		// 웹뷰는 링크를 타고 이동할 때마다 히스토리를 자동으로 저장한다. 이전페이지로 이동하는 것 역시 이미 구현되어있다.
		if webView.canGoBack { // 이동이 가능한지 여부
			webView.goBack()
		}
		// Code Input Point #3
	}
	
	@IBAction func reload(_ sender: Any) {
		// Code Input Point #5
		webView.reload()
		// Code Input Point #5
	}
	
	@IBAction func goForward(_ sender: Any) {
		// Code Input Point #4
		if webView.canGoForward { // 앞으로가기가 가능한지 여부
			webView.goForward() // 앞으로가기
		}
		// Code Input Point #4
	}
	
	func go(to urlStr: String) {
		// Code Input Point #2
		// URL 인스턴스 생성.
		guard let url = URL(string: urlStr) else {
			fatalError("Invalid URL")
		}
		
		// url request는 이름그대로 url을통해 네트워크 객체를 생성하는 객체. http메서드를 생성하거나 요청헤드를 생성하는게 가능.
		let request = URLRequest(url: url)
		
		webView.load(request) // 웹뷰에 다운로드한거 표시.
		// Code Input Point #2
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.largeTitleDisplayMode = .never
		webView.navigationDelegate = self
		
		// Code Input Point #1
		urlField.text = "http://www.apple.com" // 애플은 http로 통신하면, Code=-1022 "The resource could not be loaded because the App Transport Security policy requires the use of a secure connection. 에러가 뜬다. https로 하던가, http로하려면 app transfport security policy를 설정해야한다.
		// Code Input Point #1
	}
}

extension WebContentViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let str = textField.text else { return true }
		go(to: str)
		textField.resignFirstResponder()
		return true
	}
}

extension WebContentViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		print(error)
	}
}
