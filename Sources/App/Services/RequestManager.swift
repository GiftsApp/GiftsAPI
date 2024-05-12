//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 13.05.2024.
//

import Vapor

final class RequestManager {
    
//    MARK: - Request 1
    static func request<T: Decodable>(
        _ request: Request,
        url: URL,
        encodableModel: Encodable? = nil,
        authMode: AuthMode? = nil,
        method: RequestMethods
    ) async throws -> T {
        switch method {
        case .GET:
            let response = try await request.client.get(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return try JSONDecoder().decode(T.self, from: .init(buffer: buffer))
        case .PUT:
            let response = try await request.client.put(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return try JSONDecoder().decode(T.self, from: .init(buffer: buffer))
        case .POST:
            let response = try await request.client.post(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return try JSONDecoder().decode(T.self, from: .init(buffer: buffer))
        case .DELETE:
            let response = try await request.client.delete(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return try JSONDecoder().decode(T.self, from: .init(buffer: buffer))
        }
    }
    
//    MARK: - Request 2
    static func request(
        _ request: Request,
        url: URL,
        encodableModel: Encodable? = nil,
        authMode: AuthMode? = nil,
        method: RequestMethods
    ) async throws {
        switch method {
        case .GET:
            let response = try await request.client.get(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
        case .PUT:
            let response = try await request.client.put(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
        case .POST:
            let response = try await request.client.post(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
        case .DELETE:
            let response = try await request.client.delete(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
        }
    }
    
//    MARK: - Request 3
    static func request(
        _ request: Request,
        url: URL,
        encodableModel: Encodable? = nil,
        authMode: AuthMode? = nil,
        method: RequestMethods
    ) async throws -> Data {
        switch method {
        case .GET:
            let response = try await request.client.get(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return .init(buffer: buffer)
        case .PUT:
            let response = try await request.client.put(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return .init(buffer: buffer)
        case .POST:
            let response = try await request.client.post(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return .init(buffer: buffer)
        case .DELETE:
            let response = try await request.client.delete(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let encodableModel else { return }
                    
                    try clientReq.content.encode(encodableModel, using: JSONEncoder())
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return .init(buffer: buffer)
        }
    }
    
//    MARK: - Request 4
    static func request(
        _ request: Request,
        url: URL,
        bodyData: Data? = nil,
        authMode: AuthMode? = nil,
        method: RequestMethods
    ) async throws {
        switch method {
        case .GET:
            let response = try await request.client.get(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
        case .PUT:
            let response = try await request.client.put(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
        case .POST:
            let response = try await request.client.post(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
        case .DELETE:
            let response = try await request.client.delete(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
        }
    }
    
//    MARK: - Request 5
    static func request(
        _ request: Request,
        url: URL,
        bodyData: Data? = nil,
        authMode: AuthMode? = nil,
        method: RequestMethods
    ) async throws -> Data {
        switch method {
        case .GET:
            let response = try await request.client.get(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return .init(buffer: buffer)
        case .PUT:
            let response = try await request.client.put(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return .init(buffer: buffer)
        case .POST:
            let response = try await request.client.post(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return .init(buffer: buffer)
        case .DELETE:
            let response = try await request.client.delete(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return .init(buffer: buffer)
        }
    }
    
//    MARK: - Request 6
    static func request<T: Decodable>(
        _ request: Request,
        url: URL,
        bodyData: Data? = nil,
        authMode: AuthMode? = nil,
        method: RequestMethods
    ) async throws -> T {
        switch method {
        case .GET:
            let response = try await request.client.get(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return try JSONDecoder().decode(T.self, from: .init(buffer: buffer))
        case .PUT:
            let response = try await request.client.put(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return try JSONDecoder().decode(T.self, from: .init(buffer: buffer))
        case .POST:
            let response = try await request.client.post(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return try JSONDecoder().decode(T.self, from: .init(buffer: buffer))
        case .DELETE:
            let response = try await request.client.delete(
                .init(string: url.absoluteString),
                beforeSend: { clientReq in
                    if let authMode {
                        switch authMode {
                        case .base(email: let email, password: let password):
                            clientReq.headers.basicAuthorization = .init(username: email, password: password)
                        case .bearrer(token: let token):
                            clientReq.headers.bearerAuthorization = .init(token: token)
                        }
                    }
                    
                    guard let bodyData else { return }
                    
                    try clientReq.content.encode(bodyData, as: .formData)
                }
            )
            
            guard response.status.code == 200 else { throw RequestErrors.statusCodeIsEqualTo(code: .init(response.status.code)) }
            guard let buffer = response.body else { throw RequestErrors.dataIsEqualToNil }
            
            return try JSONDecoder().decode(T.self, from: .init(buffer: buffer))
        }
    }
    
}
