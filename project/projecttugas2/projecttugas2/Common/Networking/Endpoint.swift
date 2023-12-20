import Foundation
import Alamofire

enum Endpoint {
    case fetchCoffee
    case getDetailCoffee(Int)
    
    case fetchNewsCoffee
    case getDetailNews(String)
    
    case getPromotion
    case getDetailPromotion(String)
    
    case getPayment
    case getDetailPayment(String)
    
    case getOutlet
    case getDetailOutlet(String)
    
    func path() -> String {
        switch self {
        case .getDetailCoffee(let id):
            return "/api/\(id)"
        case .fetchCoffee:
            return "/api"
        case .fetchNewsCoffee:
            return "/v2/everything?q=coffee?&apiKey=be1e6dbfd8a4480094982f4391514919"
            //return "api/kumparan-news"
        case .getDetailNews(let url):
            return "/news/\(url)"
        case .getPromotion:
            return "/promotion"
        case .getDetailPromotion(let id):
            return "/promotion/\(id)"
        case .getPayment:
            return "/payment"
        case .getDetailPayment(let id):
            return "/payment/\(id)"
        case .getOutlet:
            return "/coffeeoutlet"
        case .getDetailOutlet(let name):
            return "/coffeeoutlet/\(name)"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .fetchCoffee, .getDetailCoffee(_), .fetchNewsCoffee, .getDetailNews(_), .getPromotion, .getDetailPromotion(_), .getPayment, .getDetailPayment(_), .getOutlet, .getDetailOutlet(_):
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchCoffee, .fetchNewsCoffee, .getPromotion, .getPayment, .getOutlet:
            return nil
        case .getDetailCoffee(_), .getDetailPromotion(_), .getDetailNews(_), .getDetailPayment(_), .getDetailOutlet(_):
            let params: [String: Any] = [:]
            return params
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fetchCoffee, .getDetailCoffee, .fetchNewsCoffee, .getDetailNews, .getPromotion, .getDetailPromotion, .getPayment, .getDetailPayment, .getOutlet, .getDetailOutlet:
            let params: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            return params
        }
    }
    
    func urlString() -> String {
        switch self {
        case .fetchCoffee, .getDetailCoffee:
            return BaseConstant.FakeCoffeeApi.baseURL + self.path()
        case .fetchNewsCoffee, .getDetailNews:
            return BaseConstant.NewsApi.newsURL + self.path()
        case .getPromotion, .getDetailPromotion:
            return BaseConstant.PromotionApi.promoURL + self.path()
        case .getPayment, .getDetailPayment(_):
            return BaseConstant.PaymentApi.paymentURL + self.path()
        case .getOutlet, .getDetailOutlet(_):
            return BaseConstant.CoffeeOutletApi.outletURL + self.path()
        
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .fetchCoffee, .fetchNewsCoffee, .getPromotion, .getPayment, .getDetailNews(_), .getDetailCoffee(_), .getDetailPromotion(_), .getDetailPayment(_), .getOutlet, .getDetailOutlet(_):
            return URLEncoding.queryString
            //            case .postUserAnime:
            //                return JSONEncoding.default
        }
    }
}
