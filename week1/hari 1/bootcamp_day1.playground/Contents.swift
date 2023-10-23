
import Foundation

var greeting = "Hello, playground"

//variable default kosong
var nama:String = String()

var number: Int = Int()


//desimal
var numberFloat = 7.1
numberFloat = 3.0

print(type(of: numberFloat))


nama = "ivan"

//cara print memanggil dengan kalimat string
print("Hallo Nama Saya \(nama.lowercased())")


//let merupakan nilai constant
let phi: Double = 3.14
//phi = 2.76

print(phi)

//kondisi yang opsional bisa ada atau tidak
var sekolah: String?

print(sekolah ?? "")


print(number)


// inisiasi banyak variable
var red, green, blue, yellow :Double

//penggunaan boolean variabel
let orangeAreOrange = true
let turnipsAreDelicious = false


//array
var kelompokHewan: [String] = ["sapi", "babi", "kerbau"]

/*Anda menggunakan opsional dalam situasi di mana suatu nilai mungkin tidak ada. Opsional mewakili dua kemungkinan: Terdapat nilai dari tipe tertentu, dan Anda dapat membuka opsi untuk mengakses nilai tersebut, atau tidak ada nilai sama sekali*/

let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)

print(convertedNumber ?? "")

var serverResponseCode: Int? = 404

serverResponseCode = nil

print(serverResponseCode ?? "")

if serverResponseCode != nil {
    print("convertedNumber contains some integer value.")
}

// Optional Binding adalah untuk penjagaan ketika datanya valid dia baru bisa di eksekusi
if let actualNumber = Int(possibleNumber) {
    print("The string \"\(possibleNumber)\" has an integer value of \(actualNumber)")
} else {
    print("The string \"\(possibleNumber)\" couldn't be converted to an integer")
}

// bisa juga di gunakan untuk banyak kondisi seperti ini

if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}


//guard let adalah penjagaan yang apabila tidak sesuai kondisi maka blok fungsi akan di berhentikan
//guard dipake untuk data opsional null
func checkGuardLet() {
    guard let number = Int(possibleNumber) else {
         fatalError("The Number Was Invalid")
    }
    print(number)
}

checkGuardLet()

//condition

var isKeren: Bool = true
var isArtis: Bool = false
var isKaya: Bool = true

//tanda kurung di eksekusi lebih dulu
if (isKeren && isArtis) || isKaya {
    print("dia dipuja - puja")
    
}else {
    print("gak keren cuyy")
}

//switch case

enum Days: String, CaseIterable {
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    func description()-> String {
        switch self {
        case .Sunday, .Saturday:
            return "Hari Libur Cuy"
        case .Monday, .Tuesday, .Friday, .Wednesday:
            return "Hari Kerja"
        default: return "Cuti Dulu"
        }
    }
}

var namaHari : Days = Days.Friday
print(Days.allCases.count)
print(namaHari)


//operator
//assignment operator
let b = 10
var a = 5
a = b
//variabel a di isi variabel maka di tumpuk

//assignment dengan tuple
let (x, y ) = (1,2)
// x di isi dengan 1, y di isi dengan 2



