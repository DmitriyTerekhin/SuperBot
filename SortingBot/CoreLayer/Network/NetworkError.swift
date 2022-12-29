//
//  NetworkError.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case domainError
    case decodingError
    case explicitlyCancelledError
    case responseError(String)
    case serverError(String)
    case customError(Int, String)
    case AFError(AFError)
    
    var textToDisplay: String {
        switch self {
        case .decodingError:
            return "Something went wrong in decoding files"
        case .responseError(_):
            return "Something went wrong with response"
        case .serverError(_):
            return "Something went wrong..."
        case .domainError:
            return "Domain error"
        case .customError(_, let description):
            return description
        case .AFError(let error):
            switch error {
            case .sessionTaskFailed(error: let thisError), .createUploadableFailed(error: let thisError),  .createURLRequestFailed(error: let thisError), .downloadedFileMoveFailed(error: let thisError, source: _, destination: _), .requestAdaptationFailed(error: let thisError), .requestRetryFailed(retryError: _, originalError: let thisError):
                return thisError.localizedDescription
            case .multipartEncodingFailed(let reason):
                return "\(reason)"
            case .explicitlyCancelled:
                return "Cancelled"
            case .invalidURL(url: _):
                return "Invalid URL"
            case .parameterEncoderFailed(reason: let reason):
                return "\(reason)"
            case .parameterEncodingFailed(reason: let reason):
                return "\(reason)"
            case .responseSerializationFailed(reason: let reason):
                return "\(reason)"
            case .responseValidationFailed(reason: let reason):
                return "\(reason)"
            case .serverTrustEvaluationFailed(reason: let reason):
                return "\(reason)"
            case .sessionDeinitialized:
                return "Session Deinitialized"
            case .urlRequestValidationFailed(reason: let reason):
                return "\(reason)"
            case .sessionInvalidated(error: let thisError):
                return thisError?.localizedDescription ?? ""
            }
        case .explicitlyCancelledError:
            return "Explicitly Cancelled Error"
        }
    }
}
