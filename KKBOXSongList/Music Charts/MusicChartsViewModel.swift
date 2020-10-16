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
    var playlists: [KKPlaylistInfo] = []
    
    private let API = KKBOXAPIManager.shared.API
    private let tableViewShouldReloadRelay = PublishRelay<()>()
    
    init() {
        tableViewShouldReload = tableViewShouldReloadRelay.asSignal()
        fetchCharts()
    }

    private func fetchCharts() {
        guard KKBOXAPIManager.shared.hasAccessToken else { return }
        
        _ = try? KKBOXAPIManager.shared.API.fetchCharts(callback: { [weak self] result in
            switch result {
            case .error(let error):
                print("Fetching Charts Failed. Error: \(error).")
            case .success(let charts):
                self?.playlists = charts.playlists
                self?.tableViewShouldReloadRelay.accept(())
                print("Fetching Charts Succeeded. Charts: \(charts.playlists).")
            }
        })
    }
}

