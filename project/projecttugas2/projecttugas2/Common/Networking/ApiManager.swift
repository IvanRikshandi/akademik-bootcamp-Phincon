import Foundation
import Alamofire

// tanpa rx
//final class ApiManager {
//    static let shared = ApiManager()
//    private init() {}
//
//    enum APIError: Error {
//        case failedToCreateRequest
//        case failedToGetData
//    }
//
//    public func fetchRequest<T: Codable>(endpoint: Endpoint,
//                                         expecting type: T.Type,
//                                         completion: @escaping(Result<T, Error>) -> Void) {
//        guard let urlRequest = self.request(endpoint: endpoint) else {
//            completion(.failure(APIError.failedToCreateRequest))
//            return
//        }
//
//        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, _, error in guard let data = data, error == nil else {
//            print("error shared")
//            completion(.failure(APIError.failedToGetData))
//            return
//        }
////            print("Raw Data:", String(data: data, encoding: .utf8) ?? "")
//            do{
////                print("Data Before Decoding:", String(data: data, encoding: .utf8) ?? "")
//                let result = try JSONDecoder().decode(type.self, from: data)
//                completion(.success(result))
//            } catch {
//                print("gagal decode")
//                print("Failed to decode, trying to encode...")
//                do {
//                    let encodedData = try JSONEncoder().encode(data)
////                    print("Data After Encoding:", String(data: encodedData, encoding: .utf8) ?? "")
//                    let result = try JSONDecoder().decode(type.self, from: encodedData)
//                    completion(.success(result))
//                } catch {
//                    print("Failed to encode as well")
//                    completion(.failure(error))
//                }
//            }
//        }).resume()
//    }
//    public func request(endpoint: Endpoint) -> URLRequest? {
//        var url : URL {
//            return URL(string: endpoint.urlString()) ?? URL(string: "")!
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = endpoint.method()
//        request.allHTTPHeaderFields = endpoint.headers as? [String : String]
//        return request
//    }
//}
enum APIError: Error {
    case unauthorized
    case internalServerError
    case badRequest
    case notFound
    case conflict
    case unknownError
}

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    public func fetchRequest<T: Codable>(endpoint: Endpoint, completion: @escaping(Result<T, Error>)-> Void){
        AF.request(endpoint.urlString(),
                   method: endpoint.method(),
                   parameters: endpoint.parameters,
                   encoding: endpoint.encoding,
                   headers: endpoint.headers).validate().responseDecodable(of: T.self) { response in
            
            switch response.result {
            case .success(let decodedObject):
                completion(.success(decodedObject))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

