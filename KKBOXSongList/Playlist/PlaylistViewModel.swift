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
    var tracksList: [KKTrackInfo] = []
    
    private let type: PlaylistType
    private let id: String
    private let tableViewShouldReloadRelay = PublishRelay<()>()
    
    init(type: PlaylistType, id: String) {
        self.type = type
        self.id = id
        tableViewShouldReload = tableViewShouldReloadRelay.asSignal()
        fetchTracks(id: id)
    }

    private func fetchTracks(id: String) {
        switch type {
        case .album:
            KKBOXAPIManager.shared.fetchTracksInAlbums(albumId: id) { [weak self] tracksList in
                self?.tracksList = tracksList.tracks
                self?.tableViewShouldReloadRelay.accept(())
            }
        case .playlist:
            KKBOXAPIManager.shared.fetchTracksInPlaylist(playlistId: id) { [weak self] tracksList in
                self?.tracksList = tracksList.tracks
                self?.tableViewShouldReloadRelay.accept(())
            }
        }
    }
}

enum PlaylistType {
    case album
    case playlist
}
