//
//  RequestSender.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class RequestSender: IRequestSender {
    
    @discardableResult
    func send<Parser>(requestConfig: ApiRequestConfig<Parser>,
                      completionHandler: @escaping (Swift.Result<Parser.Model, NetworkError>) -> Void) -> DataRequest where Parser : IParser {
        
        let request = AF.request(requestConfig.endPoint)
            .responseJSON(queue: .global(qos: .background), options: .allowFragments) { (response) in
                switch response.result {
                case .success(let jsonAny):
                    let json = JSON(jsonAny)
                    print(json)
                    if let error = requestConfig.parser.parseOnError(json: json) {
                        completionHandler(.failure(error))
                        return
                    }
                    
                    guard let model = requestConfig.parser.parse(json: json) else {
                        completionHandler(.failure(NetworkError.decodingError))
                        return
                    }
                    
                    completionHandler(.success(model))
                case .failure(let error):
                    print(error)
                    if error.isExplicitlyCancelledError == true {
                        completionHandler(.failure(.explicitlyCancelledError))
                    } else {
                        completionHandler(.failure(NetworkError.responseError(error.localizedDescription)))
                    }
                }
        }
        return request
    }
}
