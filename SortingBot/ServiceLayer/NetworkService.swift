//
//  NetworkService.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation

protocol INetworkService {
    func getCountry(ip: String?, completion: @escaping (Result<LaunchModel, NetworkError>) -> Void)
    func loadLink(completion: @escaping(Result<String, NetworkError>) -> Void)
    func makeAuth(code: String, completion: @escaping(Result<AuthModel, NetworkError>) -> Void)
    func makeAuth(token: String, completion: @escaping(Result<String, NetworkError>) -> Void)
    func sendPushToken(token: String, countryCode: String)
    func revokeToken(appleId: String)
    func addPremium(completion: @escaping (Result<(Bool, String), NetworkError>) -> Void)
    func deleteProfile(completion: @escaping(Result<Bool, NetworkError>) -> Void)
}

class NetworkService: INetworkService {
    
    let requestSender: IRequestSender

    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }

    func getCountry(ip: String?, completion: @escaping (Result<LaunchModel, NetworkError>) -> Void) {
        requestSender.send(requestConfig: ConfigFactory.getCountries(ip: nil),
                           completionHandler: completion)
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
    func sendPushToken(token: String, countryCode: String) {
        requestSender.send(requestConfig: ConfigFactory.savePushToken(token: token, country: countryCode)) { _ in }
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
