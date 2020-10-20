//
//  KKBOXAPIManager.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/15.
//

import KKBOXOpenAPISwift

class KKBOXAPIManager {
    static let shared = KKBOXAPIManager()
    let API = KKBOXOpenAPI(clientID: "badfec606bd902d5fb9a3208c10bf8e9", secret: "d1aff23b93e44241171944ac2db1fa3d")
    var hasAccessToken: Bool {
        return API.accessToken != nil
    }
    
    init() {
        fetchAccessToken()
    }
    
    private func fetchAccessToken() {
        _ = try? API.fetchAccessTokenByClientCredential { result in
            switch result {
            case .error(let error):
                print("Fetching access token failed. Error: \(error).")
            case .success(_):
                print("Fetching access token succeeded.")
            }
        }
    }
}
