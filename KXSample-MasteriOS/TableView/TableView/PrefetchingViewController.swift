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

class PrefetchingViewController: UIViewController {
	
	@IBOutlet weak var listTableView: UITableView!
	
	lazy var refreshControl: UIRefreshControl = { [weak self] in
		let control = UIRefreshControl()
		control.tintColor = self?.view.tintColor
		return control
		}()
	
	@objc func refresh() {
		DispatchQueue.global().async { [weak self] in
			guard let strongSelf = self else { return }
			strongSelf.list = Landscape.generateData()
			strongSelf.downloadTasks.forEach { $0.cancel() }
			strongSelf.downloadTasks.removeAll()
			Thread.sleep(forTimeInterval: 2)
			
			DispatchQueue.main.async {
				strongSelf.listTableView.reloadData()
				strongSelf.listTableView.refreshControl?.endRefreshing()
			}
		}
	}
	
	var list = Landscape.generateData()
	var downloadTasks = [URLSessionTask]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 델리게이트 선언.
		listTableView.prefetchDataSource = self
		
		// refreshControl속성을 선언하면, pull to refresh 만들 수 있다.
		listTableView.refreshControl = refreshControl
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
	}
}

// 프리팻칭 델리게이트.
extension PrefetchingViewController: UITableViewDataSourcePrefetching {
	// 다음에표시될 셀을 판단하고 이 메서드를 호출한다. 샐위치는 두번째 파라미터에서 받아온다. 미리 읽어오자.
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		for indexPath in indexPaths {
			downloadImage(at: indexPath.row)
		}
		print(#function, indexPaths)
	}
	
	// Prefetching대상에서 제외된 cell이 있을 때 호출.
	func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		// 로그 출력 후, 다운로드 중인 것 캔슬.
		print(#function, indexPaths)
		for indexPath in indexPaths {
			cancelDownload(at: indexPath.row)
		}
	}
}


extension PrefetchingViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		if let imageView = cell.viewWithTag(100) as? UIImageView {
			// list에 이미지가 있다면, 보여주고 없으면 다운로드해라.
			if let image = list[indexPath.row].image {
				imageView.image = image
			} else {
				imageView.image = nil
				downloadImage(at: indexPath.row)
			}
		}
		
		if let label = cell.viewWithTag(200) as? UILabel {
			label.text = "#\(indexPath.row + 1)"
		}
		
		return cell
	}
}


extension PrefetchingViewController {
	func downloadImage(at index: Int) {
		// 1. 다운로드 한 이미지가 있는지. 아니면 다운받을 필요 없다.
		guard list[index].image == nil else {
			return
		}
		
		// 2. 동일한 이미지를 다운로드하고있는 작업이 존재하는지 확인. 중복 다운로드 방지. 프리팻칭으로 같은인덱스 여러번 호출하더라도, 문제 없게하도록.
		let targetUrl = list[index].url
		guard !downloadTasks.contains(where: { $0.originalRequest?.url == targetUrl }) else {
			return
		}
		
		print(#function, index)
		
		let task = URLSession.shared.dataTask(with: targetUrl) { [weak self] (data, response, error) in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			
			if let data = data, let image = UIImage(data: data), let strongSelf = self {
				strongSelf.list[index].image = image
				let reloadTargetIndexPath = IndexPath(row: index, section: 0)
				DispatchQueue.main.async {
					if strongSelf.listTableView.indexPathsForVisibleRows?.contains(reloadTargetIndexPath) == .some(true) {
						strongSelf.listTableView.reloadRows(at: [reloadTargetIndexPath], with: .automatic)
					}
				}
				
				strongSelf.completeTask()
			}
		}
		task.resume()
		downloadTasks.append(task)
	}
	
	func completeTask() {
		downloadTasks = downloadTasks.filter { $0.state != .completed }
	}
	
	func cancelDownload(at index: Int) {
		let targetUrl = list[index].url
		guard let taskIndex = downloadTasks.index(where: { $0.originalRequest?.url == targetUrl }) else {
			return
		}
		let task = downloadTasks[taskIndex]
		task.cancel()
		downloadTasks.remove(at: taskIndex)
	}
}















