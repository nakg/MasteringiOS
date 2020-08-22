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

class TextDelegateViewController: UIViewController {
	
	@IBOutlet weak var nameField: UITextField!
	
	@IBOutlet weak var ageField: UITextField!
	
	@IBOutlet weak var genderField: UITextField!
	
	@IBOutlet weak var emailField: UITextField!
	
	lazy var charSet = CharacterSet(charactersIn: "0123456789").inverted
	lazy var invalidGenderCharSet = CharacterSet(charactersIn: "MF").inverted
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
			super.viewWillAppear(animated)
			
			nameField.becomeFirstResponder()
	}
}

extension TextDelegateViewController {
	func alert(message: String) {
		let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
		
		let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
		alert.addAction(ok)
		
		present(alert, animated: true, completion: nil)
	}
}

extension TextDelegateViewController: UITextFieldDelegate {
	// True면 편집 종료, false면 편집 유지
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField == emailField {
			// 정규식
		}
		
		return true
	}
	
	// textfield가 변경되는 순간 호출. 2번째 파라미터에 변경되는 범위와, 3번째 파라미터에 변경되는 인자값이 전달된다. 처음에 텍스트 필드에 1에 입력되었으면, textfield.text는 아무것도 없다. 아직 shouldChangeCharactersIn return 전이기 때문에 값이 주어지지 않는다. string에는 1. 거기에 2를 추가하면 textfield.text는 1, 뒤에 string은 2가 전달된다. 2를 제거하면 string에 빈값이 전달된다. -> 삭제임을 파악 할 수 있다.
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		print("current: \(textField.text ?? "")", "string: \(string)")
		
		// 입력될 값을 미리 아는 방법(NSString 함수 이용)
		guard let currentText = textField.text as NSString? else {
			return true
		}
		let finalText = currentText.replacingCharacters(in: range, with: string)
		
		switch textField {
		// 10개의 문자만 받는 스위치문
		case nameField:
			if finalText.count > 10 {
				return false
			}
		case ageField:
			// string에 숫자제외한 값이 포함되어있다면. -> 붙여넣기도 막는다.
			if let _ = string.rangeOfCharacter(from: charSet) {
				return false
			}
			
			// 1~100만 나이로 받음.
			if let age = Int(finalText), !(1...100).contains(age) {
				return false
			}
		case genderField:
			if finalText.count > 1 {
				return false
			}
			if let _ = string.rangeOfCharacter(from: invalidGenderCharSet) {
				return false
			}
		default:
			break
		}
		
		return true
	}
	
	// return키 누를 때 호출
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case nameField:
			ageField.becomeFirstResponder()
		case ageField:
			genderField.becomeFirstResponder()
		case genderField:
			emailField.becomeFirstResponder()
		case emailField:
			emailField.resignFirstResponder()
		default:
			break
		}
		return true
	}
}
















