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

class TabBarHostViewController: UIViewController {
	
	@IBAction func presentTabBarController(_ sender: Any) {
		// 코드로 childviewcontroller 가져오기.
		let firstVC = storyboard!.instantiateViewController(withIdentifier: "FirstTabViewController")
		firstVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
		let secondVC = storyboard!.instantiateViewController(withIdentifier: "SecondTabViewController")
		let thirdVC = storyboard!.instantiateViewController(withIdentifier: "ThirdTabViewController")
		
		let tbc = UITabBarController()
		tbc.viewControllers = [firstVC, secondVC, thirdVC]
		
		tbc.modalPresentationStyle = .fullScreen
		present(tbc, animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
}
