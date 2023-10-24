//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//tugas struct
//type data integer, array, bisa diisi dengan struct lain

struct Student {
    var namaStudent: [String] = ["Agus", "Rudi", "Bowo"]
    var absen: Int
    
    init(absen: Int) {
        self.absen = absen + 4
    }
//    let nama = namaStudent.randomElement()
    
    
}
var student1 = Student(absen:0)

print("Name : \(student1.namaStudent.randomElement()!), Absen : \(student1.absen)")


//: [Next](@next)
