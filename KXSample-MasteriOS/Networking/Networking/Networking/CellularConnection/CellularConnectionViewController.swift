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

class CellularConnectionViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	
	@IBOutlet weak var cellularSwitch: UISwitch!
	
	lazy var session: URLSession = { [weak self] in
		let config = URLSessionConfiguration.default
		config.requestCachePolicy = .reloadIgnoringLocalCacheData
		
		// Code Input Point #5
		config.allowsCellularAccess = false
		// Code Input Point #5
		
		let session = URLSession(configuration: config)
		return session
		}()
	
	@IBAction func downloadImage(_ sender: Any) {
		guard let url = URL(string: picUrlStr) else {
			fatalError("Invalid URL")
		}
		
		imageView.image = nil
		
		var request = URLRequest(url: url)
		
		// Code Input Point #1
		// 리퀘스트 레벨에서 셀룰러 허용여부 선택해보자. 스위치 온 여부 넣음.
		request.allowsCellularAccess = cellularSwitch.isOn
		// Code Input Point #1
		
		startTask(using: request)
	}
	
	func startTask(using request: URLRequest) {
		let task = session.dataTask(with: request) { (data, response, error) in
			print(error ?? "Success")
			
			// Code Input Point #2
			// -1009, NSURLErrorNotConnectedToInternet
			if let error = error {
				let networkError = error as NSError
				if networkError.code == NSURLErrorNotConnectedToInternet {
					if !request.allowsCellularAccess {
						self.showCellularAlert()
					}
				}
				return
			}
			// Code Input Point #2
			
			if let data = data {
				DispatchQueue.main.async {
					let img = UIImage(data: data)
					self.imageView.image = img
				}
			}
		}
		
		task.resume()
	}
	
	// 한번만 허용하기.
	func startOneTimeTask() {
		guard let url = URL(string: picUrlStr) else {
			fatalError("Invalid URL")
		}
		
		imageView.image = nil
		var request = URLRequest(url: url)
		
		// Code Input Point #3
		request.allowsCellularAccess = true
		startTask(using: request)
		// Code Input Point #3
	}
	
	// 계속 허용.
	func allowsCellularAccess() {
		// Code Input Point #4
		cellularSwitch.setOn(true, animated: true)
		startOneTimeTask()
		// Code Input Point #4
	}
}

extension CellularConnectionViewController {
	func showCellularAlert() {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: "Cellular Connection", message: "The cellular connection is disabled. Do you want to connect this time?", preferredStyle: .alert)
			
			let connectionAction = UIAlertAction(title: "Connect This Time Only", style: .default, handler: { action in
				self.startOneTimeTask()
			})
			alert.addAction(connectionAction)
			
			let allowAction = UIAlertAction(title: "Allows Permanently", style: .default, handler: { action in
				self.allowsCellularAccess()
			})
			alert.addAction(allowAction)
			
			let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
			alert.addAction(dismissAction)
			
			self.present(alert, animated: true, completion: nil)
		}
	}
}
