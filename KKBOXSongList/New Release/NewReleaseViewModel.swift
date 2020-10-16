//
//  NewReleaseViewModel.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/15.
//

import KKBOXOpenAPISwift
import RxCocoa
import RxSwift

class NewReleaseViewModel {
    let collectionViewShouldReload: Signal<()>
    let tableViewShouldReload: Signal<()>
    var albums: [KKAlbumInfo] = []
    var playlists: [KKPlaylistInfo] = []
    
    private let API = KKBOXAPIManager.shared.API
    private let collectionViewShouldReloadRelay = PublishRelay<()>()
    private let tableViewShouldReloadRelay = PublishRelay<()>()
    private let lazyLoadingPageSize = 10
    private var playlistPageCount = 0
    private var playlistTotal = 1
    
    init() {
        collectionViewShouldReload = collectionViewShouldReloadRelay.asSignal()
        tableViewShouldReload = tableViewShouldReloadRelay.asSignal()
        fetchLatestAlbum()
        fetchFeaturedPlaylists()
    }

    private func fetchLatestAlbum() {
        guard KKBOXAPIManager.shared.hasAccessToken else { return }
        
        _ = try? KKBOXAPIManager.shared.API.fetch(newReleasedAlbumsUnderCategory: "KrdH2LdyUKS8z2aoxX", limit: 10, callback: { [weak self] result in
            switch result {
            case .error(let error):
                print("Fetching New Release Albums Categories Failed. Error: \(error).")
            case .success(let albums):
                guard let albumsInfo = albums.albums?.albums else { return }
                
                self?.albums = albumsInfo
                self?.collectionViewShouldReloadRelay.accept(())
                print("Fetching New Release Albums Categories Succeeded. albums: \(albums).")
            }
        })
    }
    
    func fetchFeaturedPlaylists() {
        guard playlistPageCount * lazyLoadingPageSize < playlistTotal,
              KKBOXAPIManager.shared.hasAccessToken else { return }
        
        _ = try? KKBOXAPIManager.shared.API.fetchFeaturedPlaylists(offset: playlistPageCount * lazyLoadingPageSize, limit: lazyLoadingPageSize, callback: { [weak self] result in
            switch result {
            case .error(let error):
                print("Fetching New Release Albums Categories Failed. Error: \(error).")
            case .success(let playListList):
                self?.playlistTotal = playListList.summary.total
                self?.playlists.append(contentsOf: playListList.playlists)
                self?.playlistPageCount += 1
                self?.tableViewShouldReloadRelay.accept(())
                print("Fetching Featured Playlists Succeeded. playlists: \(playListList.playlists).")
            }
        })
    }
}
