//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 13.05.2024.
//

import Vapor
import NIOFoundationCompat

final class FileManager {
    
//    MARK: - Get
    static func get(req: Request, with path: String) async throws -> Data {
        guard !path.isEmpty else { throw FileURLErrors.badPath }
        
        if let first = path.first, "/.".contains(first) { return .init(buffer: try await req.fileio.collectFile(at: path)) }
        
        guard let url = URL(string: path) else { throw URLErrors.notValidURL }
        
        return try await RequestManager.request(req, url: url, method: .GET)
    }
    
//    MARK: - Set
    static func set(req: Request, with path: String, data: Data) async throws {
        guard !path.isEmpty else { throw FileURLErrors.badPath }
        
        if let first = path.first, "/.".contains(first) {
            try await req.fileio.writeFile(.init(data: data), at: path)
            
            return
        }
        
        guard let url = URL(string: path) else { throw URLErrors.notValidURL }
        
        return try await RequestManager.request(req, url: url, bodyData: data, method: .PUT)
    }
    
//    MARK: - Create
    static func create(req: Request, with path: String, data: Data) async throws {
        guard !path.isEmpty else { throw FileURLErrors.badPath }
        
        if let first = path.first, "/.".contains(first) {
            try await req.fileio.writeFile(.init(data: data), at: path)
            
            return
        }
        
        guard let url = URL(string: path) else { throw URLErrors.notValidURL }
        
        return try await RequestManager.request(req, url: url, bodyData: data, method: .POST)
    }
    
}
