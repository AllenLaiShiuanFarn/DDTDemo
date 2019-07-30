//
//  APIClient.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/29.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct HTTPHeader {
    let field: String
    let value: String
}

enum URLPath: String {
    case apiAccess = "apiAccess"
}

struct APIRequest {
    var url: URL?
    let method: HTTPMethod
    let path: String?
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    
    init(url: URL?, method: HTTPMethod, path: URLPath? = nil) {
        self.url = url
        self.method = method
        self.path = path?.rawValue
    }
    
    init<Body: Encodable>(url: URL, method: HTTPMethod, path: URLPath, body: Body) throws {
        self.url = url
        self.method = method
        self.path = path.rawValue
        self.body = try JSONEncoder().encode(body)
    }
}

struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
}

extension APIResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type) throws -> APIResponse<BodyType> {
        guard let data = body else {
            throw APIError.decodingFailure
        }
        let decodeJSON = try JSONDecoder().decode(BodyType.self, from: data)
        return APIResponse<BodyType>(statusCode: self.statusCode, body: decodeJSON)
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailure
    case unknown(error: Error)
}

class APIClient {
    typealias APIClientCompletionHandler = (Result<APIResponse<Data?>, APIError>) -> Void
    
    // MARK: - Properties
    static let shared = APIClient()
    private let session = URLSession.shared
    private var baseURL = URL(string: "https://data.taipei/opendata/datalist")
    
    // MARK: - Initializer
    private init() {  }
    
    // MARK: - Public method
    func requstPlantData(withLimit limit: Int, offset: Int, completionHandler: @escaping APIClientCompletionHandler) {
        var request = APIRequest(url: baseURL, method: .get, path: .apiAccess)
        request.queryItems = [URLQueryItem(name: "scope", value: "resourceAquire"),
                              URLQueryItem(name: "rid", value: "f18de02f-b6c9-47c0-8cda-50efad621c14"),
                              URLQueryItem(name: "limit", value: "\(limit)"),
                              URLQueryItem(name: "offset", value: "\(offset)")]
        perform(request, completionHandler: completionHandler)
    }
    
    func requestPlantImage(with url: URL?, completionHandler: @escaping APIClientCompletionHandler) {
        guard let url = url else { return }
        let request = APIRequest(url: url, method: .get)
        perform(request, completionHandler: completionHandler)
    }
    
    // MARK: - Private method
    private func perform(_ request: APIRequest, completionHandler: @escaping APIClientCompletionHandler) {
        guard let baseURL = request.url else { fatalError() }
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        
        var url: URL!
        if request.path == nil {
            url = urlComponents.url
        } else {
            url = urlComponents.url?.appendingPathComponent(request.path!)
        }
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(.unknown(error: error)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.requestFailed))
                return
            }
            completionHandler(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data)))
        }
        task.resume()
    }
}
