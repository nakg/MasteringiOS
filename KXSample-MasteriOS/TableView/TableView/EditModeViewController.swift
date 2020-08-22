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

class EditModeViewController: UIViewController {
	
	var editingSwitch: UISwitch!
	@IBOutlet weak var listTableView: UITableView!
	
	var productList = ["iMac Pro", "iMac 5K", "Macbook Pro", "iPad Pro", "iPhone X", "Mac mini", "Apple TV", "Apple Watch"]
	var selectedList = [String]()
	
	@objc func toggleEditMode(_ sender: UISwitch) {
		// 그냥 .isEditing하면 애니메이션이 없다.
		listTableView.setEditing(sender.isOn, animated: true)
	}
	
	@objc func emptySelectedList() {
		productList.append(contentsOf: selectedList)
		selectedList.removeAll()
		
		listTableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		editingSwitch = UISwitch(frame: .zero)
		editingSwitch.addTarget(self, action: #selector(toggleEditMode(_:)), for: .valueChanged)
		editingSwitch.isOn = listTableView.isEditing
		
		let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(emptySelectedList))
		deleteButton.tintColor = UIColor.red
		
		navigationItem.rightBarButtonItems = [deleteButton, UIBarButtonItem(customView: editingSwitch)]
	}
}


extension EditModeViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return selectedList.count
		case 1:
			return productList.count
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		switch indexPath.section {
		case 0:
			cell.textLabel?.text = selectedList[indexPath.row]
		case 1:
			cell.textLabel?.text = productList[indexPath.row]
		default:
			break
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Selected List"
		case 1:
			return "Product List"
		default:
			return nil
		}
	}
	
	// 에디팅 가능한지 확인하는 메서드. 아래에 해당되는 cell만 편집모드를 허용한다. 특정 셀 편집 막을 때만 아래를 구현한다. 안하면 알아서 전체가 다 에딧 가능하게 된다.
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	// 사용자가 셀에표시된 삭제버튼이나 추가버튼을 누를때 호출된다. 두번째 파라미터로 어떤 버튼인지 확인 가능.
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .insert:
			let target = productList[indexPath.row]
			let insertIndexPath = IndexPath(row: selectedList.count, section: 0)
			selectedList.append(target)
			productList.remove(at: indexPath.row)
			
			if #available(iOS 11.0, *) {
				listTableView.performBatchUpdates({
					[weak self] in self?.listTableView.insertRows(at: [insertIndexPath], with: .automatic)
					self?.listTableView.deleteRows(at: [indexPath], with: .automatic)
				}, completion: nil)
			} else {
				// beginupdates ~ endupdates -> 배치 방식. 내부의 순서를 알아서 조정함. 이걸 안하면, 중간에 딜리트나 인설트하면서 숫자 꼬이는게 생겨서 크래쉬가 난다.
				listTableView.beginUpdates()
				listTableView.insertRows(at: [insertIndexPath], with: .automatic)
				listTableView.deleteRows(at: [indexPath], with: .automatic)
				listTableView.endUpdates()
			}
			
			
			
		case .delete:
			let target = selectedList[indexPath.row]
			let insertIndexPath = IndexPath(row: productList.count, section: 1)
			productList.append(target)
			selectedList.remove(at: indexPath.row)
			
			if #available(iOS 11.0, *) {
				listTableView.performBatchUpdates({
					[weak self] in self?.listTableView.insertRows(at: [insertIndexPath], with: .automatic)
					self?.listTableView.deleteRows(at: [indexPath], with: .automatic)
				}, completion: nil)
			} else {
				// beginupdates ~ endupdates -> 배치 방식. 내부의 순서를 알아서 조정함. 이걸 안하면, 중간에 딜리트나 인설트하면서 숫자 꼬이는게 생겨서 크래쉬가 난다.
				listTableView.beginUpdates()
				listTableView.insertRows(at: [insertIndexPath], with: .automatic)
				listTableView.deleteRows(at: [indexPath], with: .automatic)
				listTableView.endUpdates()
			}
		default:
			break
		}
	}
}


extension EditModeViewController: UITableViewDelegate {
	// cell을 편집할 수 있다면, 편집스타일이 무엇인지 확인한다. 이때 호출되는 메서드. 3가지 편집 스타일 중 하나를 리턴해야한다.
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		// section 별로, 첫번째 섹션은 딜리트, 두번째 섹션은 추가를 보여주게 구성.
		switch indexPath.section {
		case 0 :
			return .delete
		case 1:
			return .insert
		default :
			return .none // 순서변경 시 삭제버튼 추가버튼 비활성화 할 때 주로 사용.
		}
	}
	
	// swipe to delete 활성화 될 때 호출 된다.
	func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
		editingSwitch.setOn(true, animated: true)
	}
	
	func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
		editingSwitch.setOn(false, animated: true)
	}
	
	// swipe to delete 문구 변경
	func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
		return "Remove"
	}
}


















