//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

struct Ukuran{
    var luas: Int = 30
}

class Kelas{
    var ukuran: Int
    var vvip: String
    var vip: String
    var ekonomi: String
    
    init(ukuran: Int, vvip: String, vip: String, ekonomi: String) {
        self.ukuran = Ukuran().luas + 0
        self.vvip = vvip
        self.vip = vip
        self.ekonomi = ekonomi
    }
    
    
}
var kelasA = Kelas(ukuran: 30, vvip: "VVIP", vip: "VIP", ekonomi: "EKONOMI")
print("Ukuran luas Kelas \(kelasA.ukuran) M2, Ruangan \(kelasA.ekonomi)")

//: [Next](@next)
