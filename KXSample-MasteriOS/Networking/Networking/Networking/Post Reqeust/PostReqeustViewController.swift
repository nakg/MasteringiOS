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

struct PostData: Codable {
	let a: Int
	let b: Int
	let op: String
}

class PostReqeustViewController: UIViewController {
	
	@IBOutlet weak var leftField: UITextField!
	@IBOutlet weak var rightField: UITextField!
	@IBOutlet weak var opField: UITextField!
	
	func encodedData() -> Data? {
		guard let leftStr = leftField.text, let a = Int(leftStr) else {
			showErrorAlert(with: "Please input only the number.")
			return nil
		}
		
		guard let rightStr = rightField.text, let b = Int(rightStr) else {
			showErrorAlert(with: "Please input only the number.")
			return nil
		}
		
		guard let opStr = opField.text else {
			return nil
		}
		
		let data = PostData(a: a, b: b, op: opStr)
		
		let encoder = JSONEncoder()
		return try? encoder.encode(data)
	}
	
	@IBAction func sendPostRequest(_ sender: Any) {
		guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/calc") else {
			fatalError("Invalid URL")
		}
		
		// Code Input Point #1
		// 지금까지 데이터 테스크를 생성할때 URL인스턴스를 사용했지만, 이번에는 URL로 데이터를 전달해야하므로, URLRequest 인스턴스를 만들고, http메서드와 바디를 적절하게 설정해야한다.
		var request = URLRequest(url: url)
		
		// sample서버는 제이슨으로 데이터를 받으므로, 이를 명시적으로 지정해야한다. request인스턴스에서 컨텐트타입 헤더를 설정해야한다.
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"
		
		// serever로 전달할 데이터는 http 바디 속성에 저장한다. 엔코디드가 리턴하는 값 저장하자.
		request.httpBody = encodedData()
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				self.showErrorAlert(with: error.localizedDescription)
				print(error)
				return
			}
			
			guard let httpResponse = response as? HTTPURLResponse else {
				self.showErrorAlert(with: "Invalid Response")
				return
			}
			
			guard (200...299).contains(httpResponse.statusCode) else {
				self.showErrorAlert(with: "\(httpResponse.statusCode)")
				return
			}
			
			guard let data = data, let str = String(data: data, encoding: .utf8) else {
				fatalError("Invalid Data")
			}
			self.showInfoAlert(with: str)
		}
		task.resume()
		// Code Input Point #1
	}
}
