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

class CustomSplitViewController: UISplitViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegate = self
		
		// displayMode setting
		preferredDisplayMode = .automatic
	}
	
	func setupDefaultValue() {
		// 마스터뷰컨트롤러를 바인딩하자. 네비게이션컨트롤러 안에 있는 첫번째 컨트롤러.
		guard let nav = viewControllers.first as? UINavigationController, let masterVC = nav.viewControllers.first as? ColorListTableViewController else { return }
		guard let detailVC = viewControllers.last?.childViewControllers.first as? ColorDetailViewController else { return }
		
		detailVC.color = masterVC.list.first
		
		switch displayMode {
		case .primaryHidden, .primaryOverlay:
			detailVC.navigationItem.leftBarButtonItem = displayModeButtonItem
		default:
			detailVC.navigationItem.leftBarButtonItem = nil
		}
	}
}



extension CustomSplitViewController: UISplitViewControllerDelegate {
	// 호리즈탈 사이즈 클래스가, 컴팩트로 바뀔 때마다 호출된다. 세컨더리 뷰 컨트롤러 - 디테일뷰 컨트롤러,  프라이머리뷰컨트롤러 - 마스터뷰컨트롤러.  false -> 스프릿뷰컨트롤러가 알아서 처리, 기본구성에서는 디테일뷰 컨트롤러를 네비게이션 스택에 추가한다. true -> 스프릿뷰컨트롤러가 아무런 처리도 하지 않는다. 보통은 디테일뷰컨트롤러가 표시하는 내용을, 마스터뷰컨트롤러에 추가하는 커스텀 코드를 구현할 때만 트루를 리턴한다.
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return true // 디테일뷰사라지고 마스터뷰가 처음에 보여진다.
	}
	
	
	// displaymode로 분기하고, 프라이머리히든, 프
	func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
		switch displayMode {
		case .primaryHidden, .primaryOverlay:
			viewControllers.last?.childViewControllers.first?.navigationItem.leftBarButtonItem = displayModeButtonItem
		default:
			viewControllers.last?.childViewControllers.first?.navigationItem.leftBarButtonItem = nil
		}
	}
}
























