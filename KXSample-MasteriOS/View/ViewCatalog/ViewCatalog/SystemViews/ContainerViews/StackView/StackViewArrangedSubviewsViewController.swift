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

class StackViewArrangedSubviewsViewController: UIViewController {
	
	@IBOutlet weak var stackView: UIStackView!
	
	@IBAction func add(_ sender: Any) {
		let v = generateView()
		stackView.addArrangedSubview(v)
		
		UIView.animate(withDuration: 0.3) {
			self.stackView.layoutIfNeeded()
		}
	}
	
	@IBAction func insert(_ sender: Any) {
		let v = generateView()
		stackView.insertArrangedSubview(v, at: 0)
		
		UIView.animate(withDuration: 0.3) {
			self.stackView.layoutIfNeeded()
		}
	}
	
	@IBAction func remove(_ sender: Any) {
		guard stackView.arrangedSubviews.count > 0 else {
			return
		}
		
		let index = Int(arc4random_uniform(UInt32(stackView.arrangedSubviews.count)))
		let v = stackView.arrangedSubviews[index]
//		stackView.removeArrangedSubview(v)
//
//		UIView.animate(withDuration: 0.3) {
//			self.stackView.layoutIfNeeded()
//		}
		
		UIView.animate(withDuration: 0.3, animations: { v.isHidden = true }, completion: { finished in self.stackView.removeArrangedSubview(v)})
	}
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let v = generateView()
		v.frame = stackView.bounds
		stackView.addSubview(v)
		
	}
}

extension StackViewArrangedSubviewsViewController {
	private func generateView() -> UIView {
		let v = UIView()
		
		let r = CGFloat(arc4random_uniform(256)) / 255
		let g = CGFloat(arc4random_uniform(256)) / 255
		let b = CGFloat(arc4random_uniform(256)) / 255
		v.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
		
		return v
	}
}
