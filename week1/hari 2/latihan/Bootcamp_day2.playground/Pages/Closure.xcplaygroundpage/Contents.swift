//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"


//closure

func greet(person: String, completion: (String)->String) {
    let message = completion(person)
    print(message)
}
func simpleGreeting(name: String)-> String{
    return "Hello, \(name)!"
}

//memasukan function ke dalam parameter function

greet(person: "Ivan", completion: simpleGreeting)

//atau bisa dimasukan setelah fungsi nama lainnya adalah trailing closure

greet(person: "Ivan") { name in
    return "Hello,\(name)!"
}

//: [Next](@next)
