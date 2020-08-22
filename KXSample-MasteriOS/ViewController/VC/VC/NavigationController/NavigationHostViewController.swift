//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Softwae without restriction, including without limitation the rights
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

class NavigationHostViewController: UIViewController {
	
	@IBAction func presentNavigationController(_ sender: Any) {
		// 뷰컨트롤러, 스토리보드id로 가져오기.
		guard let rootVC = storyboard?.instantiateViewController(withIdentifier: "FirstViewController") else {return}
		
		// 다음 이동할 루트뷰를 지정. navigation controller로(이 안에 5개 임베디드 되어 있겠지.)
		let nav = UINavigationController(rootViewController: rootVC)
		
		// present방식 fullscreen할 때는, 다음 present로 이동할 뷰컨트롤러.modalPrsentationStyle = .fullscreen
		nav.modalPresentationStyle = .fullScreen
		present(nav, animated: true, completion: nil)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
}




























