import UIKit

func addition(number1: Int, number2: Int) -> Int {
    return number1 + number2
}

var addFunction = addition
addFunction(10, 30) // 40

var addClosures: (Int, Int) -> Int = {
    (number1: Int, number2: Int) in
    return number1 + number2
}

addClosures(4, 10) // 14
