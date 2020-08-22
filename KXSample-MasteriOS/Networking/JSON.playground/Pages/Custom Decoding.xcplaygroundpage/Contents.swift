//: [Previous](@previous)

import Foundation

enum DecodingError: Error {
   case unknown
   case invalidRange
}

struct Employee: Codable {
   var name: String
   var age: Int
   var address: String?
   
   //
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self) // 개별키를 디코딩 할 때
		
		name = try container.decode(String.self, forKey: .name) // 디코딩은 첫번째 파라미터로 디코딩할 형식을 전달한다.
		age = try container.decode(Int.self, forKey: .age)
		
		// 가드문으로 나이 확인. 범위 벗어났다면 인밸리드 전달하고 종료.
		guard (30...60).contains(age) else {
			throw DecodingError.invalidRange
		}
		
		address = try container.decodeIfPresent(String.self, forKey: .address)
	}
   //
}

let jsonStr = """
{
"name" : "John",
"age" : 30,
"address" : "Seoul"
}
"""

guard let jsonData = jsonStr.data(using: .utf8) else {
   fatalError()
}

let decoder = JSONDecoder()

do {
   let e = try decoder.decode(Employee.self, from: jsonData)
   dump(e)
} catch {
   print(error)
}



//: [Next](@next)
