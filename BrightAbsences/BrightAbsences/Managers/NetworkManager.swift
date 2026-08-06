//
//  NetworkManager.swift
//  BrightAbsences
//
//  Created by Umair on 06/08/2026.
//

import Foundation

enum HttpMethods: String{
    case post = "POST"
    case get = "GET"
}

final class NetworkManager{
    
    var encoder : JSONEncoder
    var decoder : JSONDecoder
    var session : URLSessionProtocol
    
    init(encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder(), session: URLSessionProtocol) {
        self.encoder = encoder
        self.decoder = decoder
        self.session = session
    }
    
    func executeRequest<T:Decodable>(urlString : String, method : HttpMethods = .get, params:Encodable? = nil) async throws -> T{
        guard let url = URL(string: urlString), ["http", "https"].contains(url.scheme) else {throw AppErrors.badUrl}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if method != .get, let body = params{
            do{
                request.httpBody = try encoder.encode(body)
            }catch{
                throw AppErrors.invalidParams
            }
        }
        let (data, res) = try await session.data(for: request, delegate: nil)
        
        guard let response = res as? HTTPURLResponse,
              200...299 ~= response.statusCode else { throw AppErrors.invalidResponse }
        
        do{
            let result = try decoder.decode(T.self, from: data)
            return result
        }catch{
            throw AppErrors.invalidData
        }
    }
}
