//
//  APIClient.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 11.03.2022.
//

import Foundation

fileprivate enum APIConstants {
    static let baseURLString = "https://api.worldoftanks.ru/wot/encyclopedia"
    static let vehiclesPath = "/vehicles/"
    static let vehiclePath = "/vehicleprofile/"
    static let applicationID = "175e7c263ea214a8c9df975c6b981e9a"
}

fileprivate enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

fileprivate struct HTTPHeader {
    let field: String
    let value: String
}

fileprivate class APIRequest {
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

fileprivate struct APIResponse<Body> {
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
    case paramsNotFound
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return tr("error.invaild_url")
        case .requestFailed:
            return tr("error.request_failed")
        case .decodingFailure:
            return tr("error.unable_to_parse")
        case .paramsNotFound:
            return tr("error.params_not_found")
        }
        
    }
}

private enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(APIError)
}

public struct APIClient {
    public init() {
    }
    
    private typealias APIClientCompletion = (APIResult<Data?>) -> Void

    private let session = URLSession.shared

    private let baseURL = URL(string: APIConstants.baseURLString)!
    
    private func perform(_ request: APIRequest,
                 timeoutInterval: TimeInterval = 30.0,
                 cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                 completion: @escaping APIClientCompletion) {
        let baseURL = baseURL
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
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed)); return
            }

            completion(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data)))
        }
        task.resume()
    }
}

extension APIClient {
    public func getVehicles(page: Int, completion: ((Result<[String: VehiclesItem], APIError>)->Void)?) {
        let limit = 10
        
        let request = APIRequest(method: .get, path: APIConstants.vehiclesPath)
        request.queryItems =  [
            URLQueryItem(name: "application_id", value: APIConstants.applicationID),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "page_no", value: "\(page)")
        ]

        self.perform(request) { (result) in
            switch result {
            case .success(let response):
                do {
                    let response = try response.decode(to: VehiclesResponse.self)
                    
                    if let data = response.body.data {
                        DispatchQueue.main.async {
                            completion?(.success(data))
                        }
                    } else if let error = response.body.error {
                        if error.code == 404 {
                            DispatchQueue.main.async {
                                completion?(.failure(.paramsNotFound))
                            }
                        }
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
    
    public func getVehicle(tankID: Int, completion: ((Result<[String: VehicleItem], APIError>)->Void)?) {        
        let request = APIRequest(method: .get, path: APIConstants.vehiclePath)
        request.queryItems =  [
            URLQueryItem(name: "application_id", value: APIConstants.applicationID),
            URLQueryItem(name: "tank_id", value: "\(tankID)")
        ]

        self.perform(request) { (result) in
            switch result {
            case .success(let response):
                do {
                    let response = try response.decode(to: VehicleResponse.self)
                    
                    if let data = response.body.data {
                        DispatchQueue.main.async {
                            completion?(.success(data))
                        }
                    } else if let error = response.body.error {
                        if error.code == 404 {
                            DispatchQueue.main.async {
                                completion?(.failure(.paramsNotFound))
                            }
                        }
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
