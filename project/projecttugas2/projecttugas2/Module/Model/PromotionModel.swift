import Foundation

// MARK: - PromoModel
struct PromoModel: Codable {
    var promos: [Promo]?
}

// MARK: - Promo
struct Promo: Codable {
    let id: Int?
    let nama, deskripsi, tanggalMulai, tanggalBerakhir: String?
    let kodePromo: String?
    let image: String?
    let percentage: Double?

    enum CodingKeys: String, CodingKey {
        case id, nama, deskripsi
        case tanggalMulai = "tanggal_mulai"
        case tanggalBerakhir = "tanggal_berakhir"
        case kodePromo = "kode_promo"
        case image, percentage
    }
}
