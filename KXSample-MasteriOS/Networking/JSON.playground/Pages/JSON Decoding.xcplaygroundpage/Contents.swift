//: [Previous](@previous)

import Foundation

struct Person: Codable {
   var firstName: String
   var lastName: String
   var age: Int
   var address: String?
}

let jsonStr = """
{
"firstName" : "John",
"age" : 30,
"lastName" : "Doe",
"address" : "Seoul"
}
"""

guard let jsonData = jsonStr.data(using: .utf8) else {
   fatalError()
}

//
// 디코딩
let decoder = JSONDecoder()

do {
	let p = try decoder.decode(Person.self, from: jsonData) // 앞에 파라미터의 타입은, 반드시 디코더블이나 코더블을 채용해야한다.
	dump(p) // instance 출력. 제이슨키와 속성의 이름이 동일하고, 제이슨에 저장되어있는 값과 속성의 형식이 동일하다면 문제 없이 디코딩 된다. 호환안되면 디코딩 실패.
} catch {
	print(error)
}
//


//: [Next](@next)
