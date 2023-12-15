import Foundation
import UIKit
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}

//contoh pemanggilan

// Example of usage
//let number = 3.14159265359
//let roundedNumber = number.rounded(toPlaces: 2)
//print(roundedNumber)  // Output: 3.14
