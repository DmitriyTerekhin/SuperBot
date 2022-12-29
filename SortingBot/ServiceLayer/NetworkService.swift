//
//  NetworkService.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation

protocol INetworkService {
    func getCountry(ip: String?, completion: @escaping (Result<AppWayByCountry, NetworkError>) -> Void)
    func loadLink(completion: @escaping(Result<String, NetworkError>) -> Void)
    func makeAuth(code: String, completion: @escaping(Result<AuthModel, NetworkError>) -> Void)
    func makeAuth(token: String, completion: @escaping(Result<String, NetworkError>) -> Void)
    func sendPushToken(token: String)
    func revokeToken(appleId: String)
    func addPremium(completion: @escaping (Result<(Bool, String), NetworkError>) -> Void)
    func deleteProfile(completion: @escaping(Result<Bool, NetworkError>) -> Void)
}

class NetworkService: INetworkService {
    
    let requestSender: IRequestSender

    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }

    func getCountry(ip: String?, completion: @escaping (Result<AppWayByCountry, NetworkError>) -> Void) {
        completion(.success(.toApp))
    }
    func loadLink(completion: @escaping(Result<String, NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.loadLink(), completionHandler: completion)
    }

    func makeAuth(code: String, completion: @escaping (Result<AuthModel, NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.auth(code: code), completionHandler: completion)
    }

    func makeAuth(token: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.auth(token: token), completionHandler: completion)
    }
    func sendPushToken(token: String) {
        requestSender.send(requestConfig: ConfigFactory.savePushToken(token: token)) { _ in }
    }
    func revokeToken(appleId: String) {
        requestSender.send(requestConfig: ConfigFactory.revokeAppleToken(appleId: appleId), completionHandler: {_ in})
    }
    func addPremium(completion: @escaping (Result<(Bool, String), NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.setPremium(), completionHandler: completion)
    }
    func deleteProfile(completion: @escaping(Result<Bool, NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.deleteProfile(), completionHandler: completion)
    }
}
