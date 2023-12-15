
import Foundation

// MARK: - CoffeeModelElement

struct CoffeeModelElement: Codable {
    let id: Int?
    let coffeeModelID: String?
    let name, description: String?
    let price: Double?
    let region: String?
    let weight: Int?
    let flavorProfile: [String]?
    let grindOption: [String]?
    let roastLevel: Int?
    let imageURL: String?
    let type_coffee: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case coffeeModelID = "_id"
        case name, description, price, region, weight, type_coffee
        case flavorProfile = "flavor_profile"
        case grindOption = "grind_option"
        case roastLevel = "roast_level"
        case imageURL = "image_url"
    }
}

enum GrindOption: Int, CaseIterable, Equatable {
    case cafetiere
    case espresso
    case filter
    case frenchPress
    case pourOver
    case wholeBean
    
    var description: String {
        switch self {
        case .cafetiere:
            return "Cafetiere"
        case .espresso:
            return "Espresso"
        case .filter:
            return "Filter"
        case .frenchPress:
            return "French press"
        case .pourOver:
            return "Pour Over"
        case .wholeBean:
            return "Whole Bean"
        }
    }
}



typealias CoffeeModel = [CoffeeModelElement]
