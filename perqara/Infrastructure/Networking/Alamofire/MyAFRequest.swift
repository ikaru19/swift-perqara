//
//  MyAFRequest.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import Cleanse
import RxSwift
import Alamofire

final class MyAFRequest {
    private var apiKey: String
    private var baseUrl: TaggedProvider<MyBaseUrl>

    init(
            apiKey: TaggedProvider<RawgAPIKey>,
            baseUrl: TaggedProvider<MyBaseUrl>
    ) {
        self.apiKey = apiKey.get()
        self.baseUrl = baseUrl
    }

    static func isNetworkConnected() -> Bool {
        if let manager = NetworkReachabilityManager() {
            return manager.isReachable
        } else {
            return false
        }
    }
    
    func injectDefaultParam(with dict: [String: Any]) -> [String: Any] {
        var header = [String: Any]()
        header["key"] = apiKey
        return header.merging(dict, uniquingKeysWith: { (_, new) in new })
    }

    func injectBaseUrl(endPoint: String) -> String {
        "\(baseUrl.get())\(endPoint)"
    }
}
