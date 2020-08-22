import UIKit

struct Person : Codable { // 코더블 프로토콜 채용.
   var firstName: String
   var lastName: String
   var birthDate: Date
   var address: String?
}

// JSON 인스턴스 생성
let p = Person(firstName: "John", lastName: "Doe", birthDate: Date(timeIntervalSince1970: 1234567), address: "Seoul")

// 인스턴스를 JSON으로 바꾸어보자. JSON Encoder사용. 제이슨인코더는 모든형식을 제이슨으로 바꿀 수 있지만 1가지 규칙이 있다.(반드시 Encodable 프로토콜을 채용해야한다. 반대는 Decodable 프로토콜을 채용해야한다. 둘다 가능하다면 Codale로 대체한다.
let encoder = JSONEncoder() // 새로운 인코더객체 생성. 인코더는 객체에 저장되어있는 데이터를 JSON형식으로 바꾸어준다.
encoder.outputFormatting = .prettyPrinted // 알아보기 쉽게 하기위해 줄바꿈 및 공백 추가.

do {
	let jsonData = try encoder.encode(p) // json문자열을 바이너리 형태로 출력한다. 보통 서버로 전달할 때에는 바이너리로 그대로 전달한다.
	
	// 데이터확인위해 강제로 문자화해서 출력해보자.
	if let jsonStr = String(data: jsonData, encoding: .utf8) {
		print(jsonStr)
	}
} catch {
	print(error)
}

//



//: [Next](@next)
