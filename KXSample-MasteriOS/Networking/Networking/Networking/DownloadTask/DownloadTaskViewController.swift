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
import AVKit

class DownloadTaskViewController: UIViewController {
	
	@IBOutlet weak var sizeLabel: UILabel!
	
	@IBOutlet weak var downloadProgressView: UIProgressView!
	
	lazy var formatter: ByteCountFormatter = {
		let f = ByteCountFormatter()
		f.countStyle = .file
		return f
	}()
	
	var targetUrl: URL {
		// 다운로드한 임시파일을 저장할 최종경로로 사용된다.
		guard let targetUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("downloadedFile.mp4") else {
			fatalError("Invalid File URL")
		}
		
		return targetUrl
	}
	
	// Code Input Point #1
	// 다운로드 태스크를 적용할 태스크를 선언한다.
	var task: URLSessionDownloadTask?
	
	// 지연속성 session
	lazy var session: URLSession = { [weak self] in
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
		return session
	}()
	// Code Input Point #1
	
	@IBAction func startDownload(_ sender: Any) {
		// 타깃 url에 파일이 있는지 확인한다음 삭제하고 있다. 매번 새로운 파일을 받기 위해.. 실제 앱에선 이렇게 안함.
		do {
			let hasFile = try targetUrl.checkResourceIsReachable()
			if hasFile {
				try FileManager.default.removeItem(at: targetUrl)
			}
		} catch {
			print(error)
		}
		
		// 드롭박스 다운로드 링크로 url 인스턴스 생성하고 있다.
		guard let url = URL(string: smallFileUrlStr) else { // 나중에서 수정
			fatalError("Invalid URL")
		}
		
		downloadProgressView.progress = 0.0
		
		// Code Input Point #2
		// 새로운 다운로드 태스크 생성하고, resume
		task = session.downloadTask(with: url)
		task?.resume()
		// Code Input Point #2
	}
	
	@IBAction func stopDownload(_ sender: Any) {
		// Code Input Point #4
		task?.cancel() // 테스크 종료 및 임시저장 파일 삭제.
		// Code Input Point #4
	}
	
	// Code Input Point #5
	var resumeData: Data? // 리쥼데이터를 임시로 저장할 속성을 생성.
	// Code Input Point #5
	
	@IBAction func pauseDownload(_ sender: Any) {
		// Code Input Point #6
		task?.cancel(byProducingResumeData: { (data) in
			self.resumeData = data // 새로운 다운로드 테스크를 만들때 사용한다. 사용자가 직접 취소 했을 때를 구현해보자.
			
		})
		// Code Input Point #6
	}
	
	@IBAction func resumeDownload(_ sender: Any) {
		// Code Input Point #7
		// 리쥼데이터 있는지 확인.
		guard let data = resumeData else {
			return
		}
		
		task = session.downloadTask(withResumeData: data) // url이 아닌, 리쥼데이터를 통해 데이터를 다운받는 태스크를 생성해보자. 리쥼데이터에는 데이터 및 다운로드할 url 모두 저장되어 있다.
		task?.resume()
		// Code Input Point #7
	}
	
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		return (try? targetUrl.checkResourceIsReachable()) ?? false
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let playerVC = segue.destination as? AVPlayerViewController {
			let player = AVPlayer(url: targetUrl)
			playerVC.player = player
			playerVC.navigationItem.title = "Play"
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Code Input Point #8
		session.invalidateAndCancel()
		// Code Input Point #8
	}
}

// Code Input Point #3
// 다운로드와 관련된 델리게이트
extension DownloadTaskViewController: URLSessionDownloadDelegate {
	// 다운로드가 진행되는 동안 반복적 호출. 다운로드된 크기와 전체크기가 전달된다.
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		let current = formatter.string(fromByteCount: totalBytesWritten)
		let total = formatter.string(fromByteCount: totalBytesExpectedToWrite)
		
		sizeLabel.text = "\(current)/\(total)"
		downloadProgressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
	}
	
	// 다운로드가 재시작 될 때 호출 -> 이 후에 바로 위 정상 델리게이트 메서드 호출된다.
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
		print("resume", fileOffset, expectedTotalBytes)
	}
	
	// 다운로드가 완료되면 호출되는 메서드.
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		print(#function)
		print(error ?? "Done")
	}
	
	// 다운로드가 완료된 파일은 이 메서드로 전달 되지 않는다. 새로운 메서드 추가. 이 메서드는 다운로드가 완료된 다음 호출된다.
	// 임시 파일이 저장되어있는 위치는 마지막 파라미터를 통해 전달된다. 이 URL은 메서드가 호출되는 동안에만 사용할 수 있다. 메서드 실행이 완료되면 url에 저장되어있는 임시파일이 삭제 된다. 이후에도 파일을 사용해야한다면, 이 메서드 안에서 컨테이너로 파일을 복사해야한다. 이게 먼저 호출되고, 그 다음에 위의 didcompletewitherror가 호출된다.
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		print(#function)
		
		// location에 실제로 파일이 있는지 확인.
		guard (try? location.checkResourceIsReachable()) ?? false else {
			return
		}
		
		// location에 파일이 존재한다면, 타겟url로 복사. 만약 타겟 url에 동일한이름을 가진 파일이 존재한다면 덮어쓰기한다.
		do {
			_ = try FileManager.default.replaceItemAt(targetUrl, withItemAt: location)
		} catch {
			fatalError(error.localizedDescription)
		}
	}
}
// Code Input Point #3
