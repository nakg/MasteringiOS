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

class BookDetailTableViewController: UITableViewController {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	lazy var formatter: DateFormatter = {
		let f = DateFormatter()
		f.dateStyle = .long
		f.timeStyle = .none
		return f
	}()
	
	// Code Input Point #3
	var book: Book?
	// Code Input Point #3
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Code Input Point #4
		titleLabel.text = book?.title
		descLabel.text = book?.desc
		dateLabel.text = formatter.string(from: book!.data)
		// Code Input Point #4
	}
	
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		guard indexPath.row == 3 else {
			return nil
		}
		
		return indexPath
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if indexPath.row == 3 {
			// Code Input Point #6
			// link가 있는지 확인하고, 전달된 link로 url 생성.
			if let link = book?.link, let url = URL(string: link) {
				// 이어서, link를 열 수 있는지 확인.
				if UIApplication.shared.canOpenURL(url) {
					// 전달된 링크를 전달한 다음, 적합한 앱을 찾아 이동시킨다. 지금처럼 웹링크를 전달하면 모바일 사파리가 실행된다.
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}
			// Code Input Point #6
		}
	}
}