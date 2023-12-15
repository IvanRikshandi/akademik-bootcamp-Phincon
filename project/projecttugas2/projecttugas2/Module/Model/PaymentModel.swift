import Foundation

struct PaymentMethod: Codable {
    let paymentMethods: [PaymentMethodElement]?
}

struct PaymentMethodElement: Codable {
    let id, name, code: String?
    let logo: String?
    let virtualAccount, description: String?
}

struct PaymentDetailModel {
    let userID: String?
    let id, namaCoffee, sizeCoffee, region: String?
    let imgUrl: String?
    let quantityCoffee: Int?
    let taxCoffee, totalHarga, discount: Double?
    let paymentId, paymentLogo, paymentName, paymentVA: String?
}
