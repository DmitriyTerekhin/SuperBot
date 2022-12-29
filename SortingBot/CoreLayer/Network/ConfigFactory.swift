//
//  ConfigFactory.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation

struct ConfigFactory {
    static func getCountries(ip: String?) -> ApiRequestConfig<CountryParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.countries(ip: ip), parser: CountryParser())
    }
    static func setPremium() -> ApiRequestConfig<SetPremiumParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.setPremium(days: nil), parser: SetPremiumParser())
    }
    static func loadLink() -> ApiRequestConfig<LinkParser> {
        return ApiRequestConfig(endPoint: SortingBotJSONEndPoint.link, parser: LinkParser())
    }
    static func deleteProfile() -> ApiRequestConfig<DeleteParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.delete, parser: DeleteParser())
    }
    static func auth(code: String) -> ApiRequestConfig<AppleAuthParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.appleAuth(code), parser: AppleAuthParser())
    }
    static func auth(token: String) -> ApiRequestConfig<AuthParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.auth(token), parser: AuthParser())
    }
    static func savePushToken(token: String) -> ApiRequestConfig<SavePushTokenParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.updatePushToken(pushToken: token), parser: SavePushTokenParser())
    }
    static func revokeAppleToken(appleId: String) -> ApiRequestConfig<AppleRevokeTokenParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.revokeAppleToken(appleId: appleId),
                                parser: AppleRevokeTokenParser())
    }
}
