//
//  ViewModel.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/15.
//

import KKBOXOpenAPISwift
import RxCocoa
import RxSwift

class KKBOXAPIManager {
    static let shared = KKBOXAPIManager()
    let API = KKBOXOpenAPI(clientID: AppConstant.KKBOXAPIClientID, secret: AppConstant.KKBOXAPISecret)
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
                print("Fetching Access Token Failed. Error: \(error).")
            case .success(_):
                print("Fetching Access Token Succeeded.")
            }
        }
    }
    
    func fetchTracksInPlaylist(playlistId: String, _ callBack: @escaping (KKTrackList) -> ()) {
        guard hasAccessToken else { return }
        
        _ = try? API.fetch(tracksInPlaylist: playlistId, callback: { result in
            switch result {
            case .error(let error):
                print("Fetching tracks in playlist failed. Error: \(error).")
            case .success(let tracksList):
                callBack(tracksList)
                print("Fetching tracks in playlist succeeded.")
            }
        })
    }
    
    func fetchTracksInAlbums(albumId: String, _ callBack: @escaping (KKTrackList) -> ()) {
        guard hasAccessToken else { return }
        
        _ = try? API.fetch(tracksInAlbum: albumId, callback: { result in
            switch result {
            case .error(let error):
                print("Fetching tracks in album failed. Error: \(error).")
            case .success(let tracksList):
                callBack(tracksList)
                print("Fetching tracks in album succeeded.")
            }
        })
    }
}
