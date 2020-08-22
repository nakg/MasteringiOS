//: [Previous](@previous)

import Foundation

enum EncodingError: Error {
	case unknown
	case invalidRange
}

struct Employee: Codable {
	var name: String
	var age: Int
	var address: String?
	
	//
	// age 에 제한을 두자.
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self) // 개별속성을 인코딩 할 때
		try container.encode(name, forKey: .name) // 첫번째 파라미터로 전달한 속성을, 두번째 파라미터로 전달한 키와 매핑시켜서 컨테이너로 저장.
		
		guard (30...60).contains(age) else {
			throw EncodingError.invalidRange // 지정된 범위 벗어났다면, 인밸리드 렌지 전달하고 끝.
		}
		
		// 가드문에서 오류가 전달되지 않앗다면 허용되는 값이다.
		try container.encode(age, forKey: .age)
		try container.encodeIfPresent(address, forKey: .address) // 옵셔널은 encodeIfPresent로 인코딩.
	}
	//
}

let p = Employee(name: "James", age: 20, address: "Seoul")


let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

do {
	let jsonData = try encoder.encode(p)
	if let jsonStr = String(data: jsonData, encoding: .utf8) {
		print(jsonStr)
	}
} catch {
	print(error)
}






//: [Next](@next)

