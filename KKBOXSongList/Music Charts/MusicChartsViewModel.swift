//
//  MusicChartsViewModel.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/16.
//

import KKBOXOpenAPISwift
import RxCocoa
import RxSwift

class MusicChartsViewModel {
    let tableViewShouldReload: Signal<()>
    var trackslist: [KKTrackInfo] = []
    
    private let API = KKBOXAPIManager.shared.API
    private let tableViewShouldReloadRelay = PublishRelay<()>()
    
    init() {
        tableViewShouldReload = tableViewShouldReloadRelay.asSignal()
        fetchCharts(playlistId: "")
    }

    private func fetchCharts(playlistId: String) {
        KKBOXAPIManager.shared.fetchTracksInPlaylist(playlistId: playlistId) { [weak self] trackList in
            self?.trackslist = trackList.tracks
            self?.tableViewShouldReloadRelay.accept(())
        }
    }
}
