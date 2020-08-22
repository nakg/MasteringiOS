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

class InterfaceOrientationViewController: UIViewController {
   
	// UIViewController 클래스에 선언된 supportedInterfaceOrientations -> 일반적으로 아이패드는 전체, 아이폰은 거꾸로 뺴고 다 지원. 이 뷰컨트롤러에서 지원할 걸 고르자.(앱전체는 plist 설정)
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return [.landscapeLeft, .landscapeRight]
	}
	
	// true를 리턴하면, 회전할때마다 지원하는거로 바뀜.
	override var shouldAutorotate: Bool {
		return true
	}
	
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
   }
}
