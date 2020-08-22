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

class SplitVCHostViewController: UIViewController {
	@IBAction func presentSplitViewController(_ sender: Any) {
		// 코드로 스프릿뷰컨트롤러 생성. 마스터뷰컨트롤러 디테일뷰컨트롤러도 생성.
		// 마스터뷰컨트롤러 생성하고, 네비게이션 컨트롤러에 임배드
		guard let masterVC = storyboard?.instantiateViewController(withIdentifier: "ColorListTableViewController") else { return }
		let nav = UINavigationController(rootViewController: masterVC)
		
		// detail Viewcontroller 생성
		guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "ColorDetailViewController") else { return }
		
		// splitviewcontroller 생성.
		let splitVC = CustomSplitViewController()
		
		// 뷰컨트롤러 설정
		splitVC.viewControllers = [nav, detailVC] // 반드시 마스터를 배열 앞에 추가해야함.
		
		// code로 사이즈 설정하기. 스와이프제스쳐 사용여부 사용하기.
		splitVC.presentsWithGesture = false
		// 사이즈 설정
		splitVC.preferredPrimaryColumnWidthFraction = 0.5 // 마스터와 디테일이 같은 너비로 표시. 컨텐츠에다라 사실 달라질 수 있다.
		splitVC.minimumPrimaryColumnWidth = 100 // 마스터뷰컨트롤러의 최소너비
		splitVC.maximumPrimaryColumnWidth = view.bounds.width / 2 // 최대너비 반영.
		
		// 마스터뷰컨트롤러가 표시될 위치
		if #available(iOS 11.0, *) {
			splitVC.primaryEdge = .trailing
		} else {
			// Fallback on earlier versions
		}
		
		
		present(splitVC, animated:  true, completion: nil)
	}
	
	@IBAction func unwindToSplitHost(_ sender: UIStoryboardSegue) {
		
	}
	
	// segue가 호출되기 직전에 호출.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? CustomSplitViewController {
			vc.setupDefaultValue()
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
}





























