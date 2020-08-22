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

class SectionIndexViewController: UIViewController {
	
	@IBOutlet weak var listTableView: UITableView!
	
	let list = Region.generateData()
	
	override func viewDidLoad() {
		super.viewDidLoad()
			
		// 칼라 편집
		listTableView.sectionIndexColor = UIColor.white
		listTableView.sectionIndexBackgroundColor = UIColor.lightGray // normal state
		listTableView.sectionIndexTrackingBackgroundColor = UIColor.darkGray // dragging state
		
	}
}

extension SectionIndexViewController: UITableViewDataSource {
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
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return list[section].title
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		//		return list.map { $0.title}
		return stride(from: 0, to: list.count, by: 2).map {list[$0].title}
	}
	
	
	// section index title을 드래그한 후, 실제 section으로 이동하기 전에 호출된다.
	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return index * 2 // 위에서 짝수만 보여주고 있으므로, 실제에 곱하기 2를 하면 맞다.
	}
}










