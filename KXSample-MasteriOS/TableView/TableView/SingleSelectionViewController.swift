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

class SingleSelectionViewController: UIViewController {
	
	let list = Region.generateData()
	
	@IBOutlet weak var listTableView: UITableView!
	
	// 랜덤으로 셀 선택하는 코드 구현.
	func selectRandomCell() {
		let section = Int(arc4random_uniform(UInt32(list.count)))
		let row = Int(arc4random_uniform(UInt32(list[section].countries.count)))
		let targetIndexPath = IndexPath(row: row, section: section)
		
		// 특정셀을 사용할 때의 메서드.
		listTableView.selectRow(at: targetIndexPath, animated: true, scrollPosition: .top)
	}
	
	// 선택된 셀의 해제 버튼.
	func deselect() {
		if let selected = listTableView.indexPathForSelectedRow {
			listTableView.deselectRow(at: selected, animated: true)
		}
		
		// 선택을 해지한 후, 1초뒤 첫번째 셀로 스크롤
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			[weak self] in
			let first = IndexPath(row: 0, section: 0)
			self?.listTableView.scrollToRow(at: first, at: .top, animated: true)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showMenu(_:)))
	}
	
	@objc func showMenu(_ sender: UIBarButtonItem) {
		let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		let selectRandomCellAction = UIAlertAction(title: "Select Random Cell", style: .default) { (action) in
			self.selectRandomCell()
		}
		menu.addAction(selectRandomCellAction)
		
		let deselectAction = UIAlertAction(title: "Deselect", style: .default) { (action) in
			self.deselect()
		}
		menu.addAction(deselectAction)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		menu.addAction(cancelAction)
		
		if let pc = menu.popoverPresentationController {
			pc.barButtonItem = sender
		}
		
		present(menu, animated: true, completion: nil)
	}
}

extension SingleSelectionViewController: UITableViewDataSource {
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
}


extension SingleSelectionViewController: UITableViewDelegate {
	// cell을 선택하기 직전, nil을 하면 선택이 되지 않는다. 주로 특정셀 선택 금지할 때 사용.
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		
		// 첫번 째 셀 선택 안되게 함.
		if indexPath.row == 0 {
			return nil
		}
		
		return indexPath
	}
	
	// 선택한 직후. 보통 선택한 셀의 메서드를 넣을 때 여기 넣는다.
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let target = list[indexPath.section].countries[indexPath.row]
		showAlert(with: target)
	}
	
	// 선택 해지하기 전에 호출. nil을 리턴하면 선택상태를 그대로 유지.
	func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
		return indexPath
	}
	
	// 해지한 직후 호출
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		print("deselected \(indexPath)")
	}
	
	// cell을 강조하기 전에 호출. true면 강조, false면 강조X.
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != 0 // 이 델리게이트에서 이걸 안하면, 실제 선택 메서드를 위에서 첫번째 셀에 막기는 했지만, 선택한 효과는 나타나게됨. 이를 막는 델리게이트.
	}
	
	// cell이 강조된 이후에 호출
	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {

	}
	
	// 강조된게 제거될 때 호출
	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
	}
}


extension UIViewController {
	func showAlert(with value: String) {
		let alert = UIAlertController(title: nil, message: value, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
		alert.addAction(okAction)
		
		present(alert, animated: true, completion: nil)
	}
}

class SingleSelectionCell: UITableViewCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		// 실제론 여기서 강조될 때 색깔 고르면 된다.
		textLabel?.textColor = UIColor(white: 217.0/255.0, alpha: 1.0)
		textLabel?.highlightedTextColor = UIColor.black
	}
	
	// 선택 상태가 바뀔 때마다 호출된다.
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	// 하이라이트 상태가 바뀔 때마다 호출된다.
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
	}
}






