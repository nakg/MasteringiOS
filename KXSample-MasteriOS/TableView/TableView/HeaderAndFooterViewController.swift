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

class SectionHeaderAndFooterViewController: UIViewController {
	
	@IBOutlet weak var listTableView: UITableView!
	
	let list = Region.generateData()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		let headerNib = UINib(nibName: "CustomHeader", bundle: nil)
		
		listTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "header")
	}
}


extension SectionHeaderAndFooterViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return list.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list[section].countries.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		let target = list[indexPath.section].countries[indexPath.row]
		cell.textLabel?.text = target
		
		return cell
	}
}



extension SectionHeaderAndFooterViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! CustomHeaderView
		
		headerView.titleLabel.text = list[section].title
		headerView.countLabel.text = "\(list[section].countries.count)"

		
		return headerView
	}
	
	// 헤더를 보여주기 직전에 호출. 데이터내용이 아닌, 시각적인 설정은 여기서 구현해야한다.
//	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//		
//		if let headerView = view as? UITableViewHeaderFooterView {
//			headerView.backgroundView?.backgroundColor = UIColor.darkGray
//			
//			headerView.textLabel?.textColor = UIColor.white
//			headerView.textLabel?.textAlignment = .center
//		}
//	}
	
	// Header를 표시하기 전에 호출. 고정된값이나 오토매틱 디맨션을 호출 할 수 있다.
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 80
	}
}














