//
//  SortingBotApiEndPoint.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation
import Alamofire

enum SortingBotApiEndPoint: ApiConfiguration {
    case delete
    case auth(String)
    case appleAuth(String)
    case countries(ip: String?)
    case setPremium(days: String?)
    case revokeAppleToken(appleId: String)
    case updatePushToken(pushToken: String)
    
    var method: HTTPMethod {
        switch self {
        case .countries, .setPremium, .appleAuth, .revokeAppleToken, .delete:
            return .get
        case .updatePushToken, .auth:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .appleAuth:
            return "/api/apauth"
        case .auth:
            return "/api/auth"
        case .delete:
            return "/api/profile/delete"
        case .countries:
            return "/api/getCountry"
        case .setPremium:
            return "/api/profile/premium"
        case .revokeAppleToken:
            return "/api/revokeToken"
        case .updatePushToken:
            return "/api/push"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .revokeAppleToken(let appleId):
            return [ApiConstants.APIParameterKey.token: appleId]
        case .auth(let token):
            return [ApiConstants.APIParameterKey.appleId: token]
        case .appleAuth(let code):
            return [ApiConstants.APIParameterKey.ident: code]
        case .countries(let ip):
            if let ip = ip {
                return [ApiConstants.APIParameterKey.ip: ip]
            }
            return nil
        case .updatePushToken(let pushToken):
            guard let token = SecureStorage.shared.getToken() else { return nil }
            return [
                ApiConstants.APIParameterKey.pushToken: pushToken,
                ApiConstants.APIParameterKey.token: token
            ]
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        default:
            return HTTPHeaders(
                [:]
            )
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlComp = NSURLComponents(string: ApiConstants.URL.mainURL.appending(path).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!
        var items = [URLQueryItem]()
        // Параметры в урле
        switch self {
        case .auth, .countries, .revokeAppleToken:
            if let parameters = parameters {
                for (key, value) in parameters {
                    if let value = value as? String {
                        items.append(URLQueryItem(name: key, value: value))
                    }
                }
            }
        case .updatePushToken, .appleAuth: break
        default:
            if let token = SecureStorage.shared.getToken() {
                items.append(URLQueryItem(name: ApiConstants.APIParameterKey.token, value: token))
            }
        }
        urlComp.queryItems = items
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        return urlRequest
    }
}
