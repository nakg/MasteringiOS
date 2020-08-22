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

class ViewManagementViewController: UIViewController {
	@IBOutlet weak var redView: UIView!
	@IBOutlet weak var greenView: UIView!
	@IBOutlet weak var blueView: UIView!
	
	var grayView: UIView?
	
	func addRandomView() {
		let v = generateRandomView()
		view.addSubview(v) // subview 배열 마지막에 추가. 가장 앞에 보이는 뷰가 루트뷰에 추가된다.
	}
	
	func insertRandomViewToBack() {
		let v = generateRandomView()
		view.insertSubview(v, at: 0) // 서브뷰배열 가장 앞에추가함. 제일 앞에깔려서 안보임.
	}
	
	func removeTopmostRandomView() {
		// 서브뷰를 제거할 때는, 슈퍼뷰가아닌 서브뷰에서 메서드를 호출해야한다.
		let topmostRandomView = view.subviews.reversed().first { $0.tag > 0}
		topmostRandomView?.removeFromSuperview()
		
	}
	
	// subview의 순서를 바꾸는 메서드는 슈퍼뷰에서 호출
	func bringRedViewToFront() {
		view.bringSubview(toFront: redView) // 이 메서드는 파라미터로 전달한 서브뷰를 가장 앞에 표시되도록 이동시킨다. subviews 배열에서는 가장 뒷쪽으로 이동한다.
	}
	
	func sendRedViewToBack() {
		view.sendSubview(toBack: redView) // 가장 뒤에표시되도록 이동시킴. 서브뷰스 배열에서 0번인덱스.
	}
	
	// 인덱스 값으로 두 뷰의 서브뷰배열에서의 위치 변경코드.
	func switchGreenViewWithBlueView() {
		guard let greenViewIndex = view.subviews.index(of: greenView) else { return }
		guard let blueViewIndex = view.subviews.index(of: blueView) else { return }
		
		view.exchangeSubview(at: greenViewIndex, withSubviewAt: blueViewIndex)
	}
	
	// 레드뷰에 새로운 그레이뷰를 추가.
	func addGrayViewToRedView() {
		grayView = generateGrayView()
		redView.addSubview(grayView!)
	}
	
	func moveGrayViewToRootView() {
		if let grayView = grayView {
			view.addSubview(grayView) // 이렇게하면, 레드뷰의 서브뷰에서 제거되고, 루트뷰의 서브뷰에 그레이뷰가 추가된다.
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 탭하면 actionsheet를 탭하고, 위에선언된 메서드들 호출.
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showMenu))
	}
}



extension ViewManagementViewController {
	@objc func showMenu() {
		let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		let addRandomViewAction = UIAlertAction(title: "Add Random View", style: .default) { [weak self] (action) in
			self?.addRandomView()
		}
		menu.addAction(addRandomViewAction)
		
		let insertRandomViewToBackAction = UIAlertAction(title: "Insert Random View to Back", style: .default) { [weak self] (action) in
			self?.insertRandomViewToBack()
		}
		menu.addAction(insertRandomViewToBackAction)
		
		let removeTopmostRandomViewAction = UIAlertAction(title: "Remove Topmost Random View", style: .default) { [weak self] (action) in
			self?.removeTopmostRandomView()
		}
		menu.addAction(removeTopmostRandomViewAction)
		
		let bringRedViewToFrontAction = UIAlertAction(title: "Bring Red View to Front", style: .default) { [weak self] (action) in
			self?.bringRedViewToFront()
		}
		menu.addAction(bringRedViewToFrontAction)
		
		let sendRedViewToBackAction = UIAlertAction(title: "Send Red View to Back", style: .default) { [weak self] (action) in
			self?.sendRedViewToBack()
		}
		menu.addAction(sendRedViewToBackAction)
		
		let switchGreenViewWithBlueViewAction = UIAlertAction(title: "Switch Green View with Blue View", style: .default) { [weak self] (action) in
			self?.switchGreenViewWithBlueView()
		}
		menu.addAction(switchGreenViewWithBlueViewAction)
		
		let addGrayViewToRedViewAction = UIAlertAction(title: "Add Gray View to Red View", style: .default) { [weak self] (action) in
			self?.addGrayViewToRedView()
		}
		menu.addAction(addGrayViewToRedViewAction)
		
		let moveGrayViewToRootViewAction = UIAlertAction(title: "Move Gray View to Root View", style: .default) { [weak self] (action) in
			self?.moveGrayViewToRootView()
		}
		menu.addAction(moveGrayViewToRootViewAction)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		menu.addAction(cancelAction)
		
		present(menu, animated: true, completion: nil)
	}
	
	// 백그라운드 색 랜덤, 태그도 0보다 큰 랜덤.
	func generateRandomView() -> UIView {
		let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
		let v = UIView(frame: frame)
		v.center = view.center
		v.backgroundColor = UIColor.random
		v.tag = Int(arc4random_uniform(UInt32(Int16.max)) + 1)
		
		return v
	}
	
	func generateGrayView() -> UIView {
		let frame = CGRect(x: 100, y: 100, width: 50, height: 50)
		let v = UIView(frame: frame)
		v.backgroundColor = UIColor.gray
		
		return v
	}
}



extension UIColor {
	static var random: UIColor {
		let r = CGFloat(arc4random_uniform(256)) / 255
		let g = CGFloat(arc4random_uniform(256)) / 255
		let b = CGFloat(arc4random_uniform(256)) / 255
		
		return UIColor(displayP3Red: r, green: g, blue: b, alpha: 1.0)
	}
}


















