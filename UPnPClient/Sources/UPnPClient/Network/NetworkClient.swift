//
//  NetworkClient.swift
//  
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation

protocol NetworkClient {
    func get<Response: Decodable>(url: URL) async throws -> Response
    func post<Response: Decodable>(url: URL, data: Data, headers: [String: String]) async throws -> Response
}
