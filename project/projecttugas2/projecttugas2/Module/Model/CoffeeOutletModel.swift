import Foundation

// MARK: - Outlet
struct Outlet: Codable {
    let coffeeoutlet: [Coffeeoutlet]?
}

// MARK: - Coffeeoutlet
struct Coffeeoutlet: Codable {
    let id: Int?
    let name, address: String?
    let latitude, longitude: Double?
    let pickupAvailable, dineInAvailable: Bool?
    let operatingHours: [OperatingHour]?
}

// MARK: - OperatingHour
struct OperatingHour: Codable {
    let day: Day?
    let openTime, closeTime: String?
}

enum Day: String, Codable {
    case mondayFriday = "Monday-Friday"
    case mondaySunday = "Monday-Sunday"
    case saturdaySunday = "Saturday-Sunday"
}
