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

class DataTaskTableViewController: UITableViewController {
	
	var list = [Book]()
	
	@IBAction func sendRequest(_ sender: Any) {
		let booksUrlStr = "https://kxcoding-study.azurewebsites.net/api/books" // 요청을 전달할 url
		
		// Code Input Point #1
		// url 인스턴스를 url스트링 이용하여 생성하자.(어떤 작업이든 이게 시작임.)
		guard let url = URL(string: booksUrlStr) else {
			fatalError("Invalid URL")
		}
		// sharedsession은 기본설정을 사용해서, 네트워크 요청을 처리한다.
		let session = URLSession.shared
		// dataTask의 메서드들을 보면 4가지로 셋팅할 수 있다. 먼저, URL인지 URLRequest인지. URLRequest를 받는 메서드는 task별로 캐쉬정책과 같은 네트워크 설정을 바꾸어야할 때 사용한다. 그리고 두번째 파라미터로 컴플리션 핸들러를 받는메서드와 그렇지 않은 메서드가 있다. 서버에서 받는 데이터를 처리하는 방법임. 델리게이트를통해 상세한 처리를 해야한다면 컴플리션 없는거로 간다. 여기에서는 url + completion
		let task = session.dataTask(with: url) { (data, response, error) in
			// 네트워크가 완료된 시점에 클로져 호출. 클로져 1번쨰 파라미터 : 서버에서 전달된 바이너리 데이터, 2.  서버 응답, 3: 오류에대한 확인. 오류가 발생하지 않았다면 nil이 전달.
			if let error = error {
				self.showErrorAlert(with: error.localizedDescription)
				print(error)
				return
			}
			
			// 2번째 파라미터는 보통 응답 코드를 확인할 때 사용한다. 확인하기 위해서는 HTTPURLResponse로 타입캐스팅 해야한다.
			guard let httpResponse = response as? HTTPURLResponse else {
				self.showErrorAlert(with: "Invalid Response")
				return
			}
			
			// 성공하면 보통 200. http응답코드에서 200~299는 성공코드이다. 아니라면 경고창 표시.
			guard (200...299).contains(httpResponse.statusCode) else {
				self.showErrorAlert(with: "\(httpResponse.statusCode)")
				return
			}
			
			// 여기부터는 정상. 상수로 데이터를 바인딩하자. data상수에는 서버에서 전달된 json형식이 저장되어있다.
			guard let data = data else {
				fatalError("Invalid Data")
			}
			
			// json은 디코더로 파싱하겠다. 먼저, json list배열에 있는 개별데이터와 동일한 구조체를 생성하자. (Model.swift)
			do {
				let decoder = JSONDecoder()
				
				// json의 date가 iso8601이므로, 더블로 인식하면 통신이 실패한다. 이를 방지하기 위해 디코딩 전략 변경.
//				decoder.dateDecodingStrategy = .iso8601
				
				// 그런데 json이 iso8601인갑 싶었지만, T ~~~~ Z중 뒤에 Z만 빼고준다.... 이 때 클라이언트에서 해결할 수 있는 방법은 2가지.
				// 디코더 자체를 커스텀 하거나, 디코더 전략을 커스텀하거나. 여기선 디코더 전략을 커스텀해보자.
				decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
					// 파싱할 날짜값은 디코더를 통해가져온다. 이값은 디코더 내부에있는 컨테이너에 저장되어있다. 싱글벨류 컨테이너 메서드로 가져오자.
					let container = try decoder.singleValueContainer()
					let dataStr = try container.decode(String.self) // 싱글벨류 컨테이너의 값을 문자열로 가져온다.
					
					let formatter = ISO8601DateFormatter()
					formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
					return formatter.date(from: dataStr)!
				})
				
				let bookList = try decoder.decode(BookList.self, from: data)
				
				// code가 200인지 확인.
				if bookList.code == 200 {
					// 200이라면 class의 list속성에 파싱된 데이터를 저장하고 테이블뷰 리로드.
					self.list = bookList.list
					DispatchQueue.main.async {
						self.tableView.reloadData()
					}
				}
				else {
					self.showErrorAlert(with: bookList.message ?? "Error")
				}
			} catch {
				print(error)
				self.showErrorAlert(with: error.localizedDescription)
			}
		}

		// 위까지는 서스팬디드 상태이다. 리쥼해야한다.
		task.resume()

		// Code Input Point #1
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destVC = segue.destination as? BookDetailTableViewController {
			if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
				// Code Input Point #5
				destVC.book = list[indexPath.row]
				// Code Input Point #5
			}
		}
	}
}

extension DataTaskTableViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		// Code Input Point #2
		let target = list[indexPath.row]
		cell.textLabel?.text = target.title
		// Code Input Point #2
		
		return cell
	}
}
