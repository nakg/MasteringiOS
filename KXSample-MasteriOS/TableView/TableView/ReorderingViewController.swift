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

class ReorderingViewController: UIViewController {
	
	var firstList = [String]()
	var secondList = [String]()
	var thirdList = ["iMac Pro", "iMac 5K", "Macbook Pro", "iPad Pro", "iPad", "iPad mini", "iPhone 8", "iPhone 8 Plus", "iPhone SE", "iPhone X", "Mac mini", "Apple TV", "Apple Watch"]
	
	@IBOutlet weak var listTableView: UITableView!
	
	@objc func reloadTableView() {
		listTableView.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		listTableView.setEditing(true, animated: false)
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(reloadTableView))
	}
}


extension ReorderingViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return firstList.count
		case 1:
			return secondList.count
		case 2:
			return thirdList.count
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		switch indexPath.section {
		case 0:
			cell.textLabel?.text = firstList[indexPath.row]
		case 1:
			cell.textLabel?.text = secondList[indexPath.row]
		case 2:
			cell.textLabel?.text = thirdList[indexPath.row]
		default:
			break
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "First Section"
		case 1:
			return "Second Section"
		case 2:
			return "Third Section"
		default:
			return nil
		}
	}
	
	// 순서바꾸는기능은 디폴트가 비활성화. 이걸 트루로 리턴하면 이동이가능. + 실제로 데이터를 이동시키는 메서드를 구현해주어야 한다.
	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	// 테이블뷰는 기본적으로 에디팅컨트롤만큼 여백을 만든다. 아래 델리게이트에서 .none을 리턴해도 없어도 마찬가지임. 이걸 false하면 여백이 사라진다. 이거까지만하면 겉으로보기에만 이동하고 데이터가 안이동하지~
	func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
		return false
	}

	// cell을 드래그해서 원하는위치에 드랍하면 호출되는 메서드. 두번째 파라미터로 시작위치, 세번째 파라미터로 최종위치를 전달함. 실제 데이터를 이동시키는 코드를 구현해야한다.
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		var target: String? = nil
		
		// 옴겨질 데이터 삭제.
		switch sourceIndexPath.section {
		case 0:
			target = firstList.remove(at: sourceIndexPath.row) // remove하면서 remove값 반환.
		case 1:
			target = secondList.remove(at: sourceIndexPath.row)
		case 2:
			target = thirdList.remove(at: sourceIndexPath.row)
		default:
			break
		}
		
		guard let item = target else { return }
		
		// 옴겨질 위치로 데이터 추가.
		switch destinationIndexPath.section {
		case 0:
			firstList.insert(item, at: destinationIndexPath.row) // append하면 순서바뀌어서 안됨.
		case 1:
			secondList.insert(item, at: destinationIndexPath.row)
		case 2:
			thirdList.insert(item, at: destinationIndexPath.row)
		default:
			break
		}
	}
	
}


extension ReorderingViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return .none // 여기서 논을한다고 편집이 금지되는게 아니라, 우측에 에디팅 컨트롤이 안뜰 뿐이다. 이거만하면 이거 크기만큼 공백이 생겨있다. 그리고 리오더링도 안보인다. 리오더링만 뜨게해보자.
	}
	
	// cell을 drop할 때 호출. 두번째에는 처음위치, 세번째에는 최종위치가 전달된다. 셀을 이동하는 최종위치는 이 메서드가 리턴하는 인덕서페스에 따라 결정된다. 세번째 파라미터를 그대로 리턴하면, 이전과 결과가 동일해진다. 이동을 불가하게 하려면, 2번째 파라미터를 결과값으로 반환하면 된다.
	func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
		
		if proposedDestinationIndexPath.section == 0 {
			return sourceIndexPath
		}
		
		return proposedDestinationIndexPath
	}
}














