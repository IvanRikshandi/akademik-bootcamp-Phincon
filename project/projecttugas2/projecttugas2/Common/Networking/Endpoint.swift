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
        }
    }
    
//    func method() -> String {
//        switch self {
//        case .fetchCoffee, .getDetailCoffee(_), .fetchNewsCoffee, .getDetailNews(_):
//            return "GET"
//        }
//    }
    
    func method() -> HTTPMethod {
        switch self {
        case .fetchCoffee, .getDetailCoffee(_), .fetchNewsCoffee, .getDetailNews(_), .getPromotion, .getDetailPromotion(_), .getPayment, .getDetailPayment(_):
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchCoffee, .fetchNewsCoffee, .getPromotion, .getPayment:
            return nil
        case .getDetailCoffee(_), .getDetailPromotion(_), .getDetailNews(_), .getDetailPayment(_):
            let params: [String: Any] = [:]
            return params
        }
    }
    
//    var headers: [String: Any]? {
//        switch self {
//        case .fetchCoffee, .getDetailCoffee, .fetchNewsCoffee, .getDetailNews:
//            let params: [String: Any]? = [
//                    "Content-Type": "application/json",
//                ]
//            return params
//        }
//    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fetchCoffee, .getDetailCoffee, .fetchNewsCoffee, .getDetailNews, .getPromotion, .getDetailPromotion, .getPayment, .getDetailPayment(_):
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
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .fetchCoffee, .fetchNewsCoffee, .getPromotion, .getPayment, .getDetailNews(_), .getDetailCoffee(_), .getDetailPromotion(_), .getDetailPayment(_):
            return URLEncoding.queryString
            //            case .postUserAnime:
            //                return JSONEncoding.default
        }
    }
}
