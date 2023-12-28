
import Foundation

struct CheckOutModelCoffee {
    var id: Int?
    var nama: String?
    var harga: Double?
    let imgUrl: String?
    var size: String?
    var quantity: Int?
    var tax: Int?
    var discount: Int?
    var total: Int?
}

struct CheckoutInfo {
    var subTotal = ""
    var taxTotal = ""
    var discountTotal = ""
    var totalHarga = 0.0
    var qty = ""
    var size = ""
    var titles = ""
    var idCoffee = ""
    var imgUrl = ""
    var index = ""
    var region = ""

}
