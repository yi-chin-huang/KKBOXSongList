//
//  PlaylistViewModel.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/16.
//

import KKBOXOpenAPISwift
import RxCocoa
import RxSwift

class PlaylistViewModel {
    let tableViewShouldReload: Signal<()>
    var tracksList: [TrackInfo] = []
    
    private let playlistInfo: PlaylistInfo
    private let tableViewShouldReloadRelay = PublishRelay<()>()
    
    init(playlistInfo: PlaylistInfo) {
        self.playlistInfo = playlistInfo
        tableViewShouldReload = tableViewShouldReloadRelay.asSignal()
        fetchTracks(id: playlistInfo.id)
    }

    private func fetchTracks(id: String) {
        switch playlistInfo.type {
        case .album:
            fetchTracksInAlbums(albumId: id)
        case .playlist:
            fetchTracksInPlaylist(playlistId: id)
        }
    }
    
    private func fetchTracksInAlbums(albumId: String) {
        guard KKBOXAPIManager.shared.hasAccessToken else { return }

        _ = try? KKBOXAPIManager.shared.API.fetch(tracksInAlbum: albumId, callback: { [weak self] result in
            switch result {
            case .success(let tracksList):
                self?.tracksList = tracksList.tracks.map({ [weak self] kkTrackInfo -> TrackInfo in
                    var trackInfo = TrackInfo(kkTrackInfo: kkTrackInfo)
                    guard let self = self else { return trackInfo }
                    
                    trackInfo.artist = self.playlistInfo.artist?.name
                    trackInfo.imageUrl = self.playlistInfo.imageUrl
                    trackInfo.releaseDate = self.playlistInfo.releaseDate
                    return trackInfo
                })
                self?.tableViewShouldReloadRelay.accept(())
            case .error(let error):
                print("Fetching tracks in album failed. Error: \(error).")
            }
        })
    }
    
    private func fetchTracksInPlaylist(playlistId: String) {
        guard KKBOXAPIManager.shared.hasAccessToken else { return }
        
        _ = try? KKBOXAPIManager.shared.API.fetch(tracksInPlaylist: playlistId, callback: { [weak self] result in
            switch result {
            case .success(let tracksList):
                self?.tracksList = tracksList.tracks.map({ return TrackInfo(kkTrackInfo: $0) })
                self?.tableViewShouldReloadRelay.accept(())
            case .error(let error):
                print("Fetching tracks in playlist failed. Error: \(error).")
            }
        })
    }
}

enum PlaylistType {
    case album
    case playlist
}

struct TrackInfo {
    var imageUrl: URL?
    let name: String
    var artist: String?
    var releaseDate: String?
    let trackUrl: URL?
    
    init(kkTrackInfo: KKTrackInfo) {
        name = kkTrackInfo.name
        imageUrl = kkTrackInfo.album?.images.first?.url
        artist = kkTrackInfo.album?.artist?.name
        releaseDate = kkTrackInfo.album?.releaseDate
        trackUrl = kkTrackInfo.url
    }
}
