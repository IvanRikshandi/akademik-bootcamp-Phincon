//
//  ExtRupiah.swift
//  projecttugas2
//
//  Created by Phincon on 27/10/23.
//

import Foundation

extension Int {
    var asRupiah: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID") // Set to Indonesian locale

        if let formattedAmount = formatter.string(from: NSNumber(value: self)) {
            return formattedAmount
        } else {
            return ""
        }
    }
}
