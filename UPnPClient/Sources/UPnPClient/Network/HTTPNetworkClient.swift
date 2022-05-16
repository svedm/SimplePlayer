//
//  HTTPNetworkClient.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation

class HTTPNetworkClient: NetworkClient {
    private let urlSession: URLSession
    private let decoder: ResponseDecoder
    
    init(
        urlSession: URLSession = .shared,
        decoder: ResponseDecoder
    ) {
        self.urlSession = urlSession
        self.decoder = decoder
    }
    
    func get<Response: Decodable>(url: URL) async throws -> Response {
        let (data, _) = try await urlSession.data(from: url)
        print("response:", String(data: data, encoding: .utf8) ?? "bad data")
        return try decoder.decode(data: data)
    }
    
    func post<Response: Decodable>(url: URL, data: Data, headers: [String: String]) async throws -> Response {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields?.merge(headers) { $1 }
        let (data, _) = try await urlSession.upload(for: request, from: data, delegate: nil)
        print("response:", String(data: data, encoding: .utf8) ?? "bad data")
        return try decoder.decode(data: data)
    }
}
