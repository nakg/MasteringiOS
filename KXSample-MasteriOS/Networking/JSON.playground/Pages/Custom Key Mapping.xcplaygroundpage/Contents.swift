//: [Previous](@previous)

import Foundation

struct Person: Codable {
	var firstName: String
	var lastName: String
	var age: Int
	var address: String?
	
	// 키매핑은 형식 구조체에서 열거형으로 선언한다. 케이스 이름은 항상 속성이름과 동일해야하며, 모든 매핑을 다 구현할 필요는 없다.
	enum CodingKeys: String, CodingKey {
		case firstName
		case lastName
		case age
		case address = "homeAddress"
	}
	//
}

let jsonStr = """
{
"firstName" : "John",
"age" : 30,
"lastName" : "Doe",
"homeAddress" : "Seoul",
}
"""
// 홈 어드레스를 어드레스로 매핑해야된다고 가정해보자. -> 커스텀매핑을 구현해야한다. 옵셔널이라 nil이 저장이 되긴 한다만.

guard let jsonData = jsonStr.data(using: .utf8) else {
	fatalError()
}

let decoder = JSONDecoder()

do {
	let p = try decoder.decode(Person.self, from: jsonData)
	dump(p)
} catch {
	print(error)
}



//: [Next](@next)
