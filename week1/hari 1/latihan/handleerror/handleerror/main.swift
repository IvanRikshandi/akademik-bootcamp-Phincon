//
//  main.swift
//  handleerror
//
//  Created by Phincon on 24/10/23.
//

import Foundation

import Foundation

enum CustomError: Error{
    case notNumber, limit
}

func checkNumber() throws -> Int {
    print("Input you number")
    if let response = readLine(), let withdraw =  Int(response){
        if withdraw > 10000 {
            throw CustomError.limit
        }else{
            return withdraw
        }
    }else {
        throw CustomError.notNumber
    }
}

do {
    let result = try checkNumber()
    print("Result: \(result)")
}catch CustomError.notNumber{
    print("input not number")
}catch CustomError.limit{
    print("Limit Cuy")
}
