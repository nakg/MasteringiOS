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


class UploadTaskViewController: UIViewController {
	
	@IBOutlet weak var sizeLabel: UILabel!
	
	@IBOutlet weak var uploadProgressView: UIProgressView!
	
	lazy var formatter: ByteCountFormatter = {
		let f = ByteCountFormatter()
		f.countStyle = .file
		return f
	}()
	
	var dropboxUploadRequest: URLRequest {
		guard let apiUrl = URL(string: "https://content.dropboxapi.com/2/files/upload") else {
			fatalError("Invalid URL")
		}
		
		var request = URLRequest(url: apiUrl)
		request.httpMethod = "POST"
		request.setValue("Bearer \(dropBoxAccessToken)", forHTTPHeaderField: "Authorization")
		request.setValue("{\"path\": \"/intro.mp4\",\"mode\": \"overwrite\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}", forHTTPHeaderField: "Dropbox-API-Arg")
		request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
		
		return request
	}
	
	// Code Input Point #2
	var uploadTask: URLSessionUploadTask?
	
	lazy var session: URLSession = { [weak self] in
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
		return session
		
	}()
	// Code Input Point #2
	
	@IBAction func uploadWithProgress(_ sender: Any) {
		guard let resourceUrl = Bundle.main.url(forResource: "intro", withExtension: "mp4") else {
			fatalError("Invalid Resource")
		}
		
		guard let data = try? Data(contentsOf: resourceUrl) else {
			fatalError("Invalid Data")
		}
		
		uploadProgressView.progress = 0.0
		
		// Code Input Point #3
		uploadTask = session.uploadTask(with: dropboxUploadRequest, from: data)
		uploadTask?.resume()
		// Code Input Point #3
	}
	
	@IBAction func upload(_ sender: Any) {
		guard let resourceUrl = Bundle.main.url(forResource: "intro", withExtension: "mp4") else {
			fatalError("Invalid Resource")
		}
		
		guard let data = try? Data(contentsOf: resourceUrl) else {
			fatalError("Invalid Data")
		}
		
		// Code Input Point #1
		let task = URLSession.shared.uploadTask(with: dropboxUploadRequest, from: data) { (data, response, error) in
			if let error = error {
				self.showErrorAlert(with: error.localizedDescription)
				print(error)
				return
			}
			
			guard let httpResponse = response as? HTTPURLResponse else {
				self.showInfoAlert(with: "Invalid Response")
				return
			}
			
			guard (200...299).contains(httpResponse.statusCode) else {
				self.showInfoAlert(with: "\(httpResponse.statusCode)")
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
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Code Input Point #5
		session.invalidateAndCancel()
		// Code Input Point #5
	}
}

// Code Input Point #4
extension UploadTaskViewController: URLSessionTaskDelegate {
	// data가 업로드되는동안 반복적으로 호출. 3번째 파라미터에는 이메서드가 호출되는 시점에 전송된 데이터 크기가, 4번째 파라미터에는 지금까지 전송된 전체 크기가, 마지막 파라미터에는 전송할 전체크기가 전달된다.
	func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
		let current = formatter.string(fromByteCount: totalBytesSent)
		let total = formatter.string(fromByteCount: totalBytesExpectedToSend)
		sizeLabel.text = "\(current)/\(total)"
		
		uploadProgressView.progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
	}
	
	// upload가 완료되거나 오류가 발생하면 호출.
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		print(error ?? "Done")
	}
}
// Code Input Point #4
