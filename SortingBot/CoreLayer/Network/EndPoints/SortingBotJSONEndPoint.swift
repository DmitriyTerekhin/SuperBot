//
//  SortingBotJSONEndPoint.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation
import Alamofire

enum SortingBotJSONEndPoint: ApiConfiguration {
    case link
    
    var method: HTTPMethod {
        switch self {
        case .link:
            return .get
        }
    }

    var path: String {
        switch self {
        case .link:
            return ""
        }
    }
    
    var parameters: [String: Any]? {
        return [:]
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
        var urlRequest = URLRequest(url: URL(string: ApiConstants.URL.countryLink)!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        return urlRequest
    }
}
