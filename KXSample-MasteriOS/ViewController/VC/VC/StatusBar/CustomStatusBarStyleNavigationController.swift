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

class CustomStatusBarStyleNavigationController: UINavigationController {
	
	// 항상 마지막에 푸쉬된 차일드가 스테이터스바 히든 여부를 결정한다.
	override var childViewControllerForStatusBarHidden: UIViewController? {
		return topViewController
	}
	
	// 항상 마지막에 푸쉬된 차일드가 스테이터스바  스타일을 결정한다.
	override var childViewControllerForStatusBarStyle: UIViewController? {
		return topViewController
	}
	
	// 홈인디케이터 표시여부를 탑뷰가 결정해라.
	override func childViewControllerForHomeIndicatorAutoHidden() -> UIViewController? {
		return topViewController
	}
}
