//
//  APIClient.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 11.03.2022.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

public struct HTTPHeader {
    let field: String
    let value: String
}

public class APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?

    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
    }

    init<Body: Encodable>(method: HTTPMethod, path: String, body: Body) throws {
        self.method = method
        self.path = path
        self.body = try JSONEncoder().encode(body)
    }
}

public struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
}

extension APIResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type) throws -> APIResponse<BodyType> {
        guard let data = body else {
            throw APIError.decodingFailure
        }
        let decodedJSON = try JSONDecoder().decode(BodyType.self, from: data)
        return APIResponse<BodyType>(statusCode: self.statusCode,
                                     body: decodedJSON)
    }
}

public enum APIError: String, LocalizedError {
    case invalidURL
    case requestFailed
    case decodingFailure
    case fieldNotFound
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid url"
        case .requestFailed:
            return tr("error.request_failed")
        case .decodingFailure:
            return "Unable to parse response."
        case .fieldNotFound:
            return tr("error.face_not_found")
        }
        
    }
}

public enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(APIError)
}

public struct APIClient {
    public init() {
    }
    
    public typealias APIClientCompletion = (APIResult<Data?>) -> Void

    private let session = URLSession.shared

    static let baseURL = URL(string: "https://api.worldoftanks.ru/wot/encyclopedia")!
    
    public func perform(_ request: APIRequest,
                 timeoutInterval: TimeInterval = 30.0,
                 cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                 completion: @escaping APIClientCompletion) {
        let baseURL = APIClient.baseURL
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems

        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(.failure(.invalidURL)); return
        }

        var urlRequest = URLRequest(url: url, timeoutInterval: timeoutInterval)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body

        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        
        print("[Request]: \(urlRequest.description)")
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed)); return
            }

            print("[Response]: \(httpResponse.statusCode) \(httpResponse.url!.absoluteString)")
            if let data = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]) {
                print("[Response data]: \(String(data: jsonData, encoding: .utf8) ?? "empty")")
            }

            completion(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data)))
        }
        task.resume()
    }
}

extension APIClient {
    public func getVehicles(completion: ((Result<[ResponseItem], APIError>)->Void)?) {
        
        let request = APIRequest(method: .get, path: "/vehicles/")
        request.queryItems =  [
            URLQueryItem(name: "application_id", value: "175e7c263ea214a8c9df975c6b981e9a"),
            URLQueryItem(name: "limit", value: "2"),
            URLQueryItem(name: "page_no", value: "1")
        ]

        self.perform(request) { (result) in
            switch result {
            case .success(let response):
                do {
                    print(response)
                    if response.statusCode == 404 {
                        DispatchQueue.main.async {
                            completion?(.failure(.fieldNotFound))
                        }
                        return
                    }
                    let response = try response.decode(to: Response.self)

                    DispatchQueue.main.async {
                        completion?(.success(response.body.result))
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        completion?(.failure(.decodingFailure))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
            }
        }
    }
    
}
