//
//  URLSessionProtocol.swift
//  BrightAbsences
//
//  Created by Umair on 06/08/2026.
//

import Foundation

protocol URLSessionProtocol{
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession : URLSessionProtocol{
    
}
