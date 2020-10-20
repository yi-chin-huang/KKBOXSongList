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
        fetchLatestAlbumCategories()
        fetchFeaturedPlaylists()
    }
    
    private func fetchLatestAlbumCategories() {
        guard KKBOXAPIManager.shared.hasAccessToken else { return }
        
        _ = try? KKBOXAPIManager.shared.API.fetchNewReleaseAlbumsCategories(callback: { [weak self] result in
            switch result {
            case .success(let newReleaseAlbumCategories):
                guard let categoryId = newReleaseAlbumCategories.categories.first?.ID else { return }
                
                self?.fetchLatestAlbumsUnderCategorie(categoryId: categoryId)
            case .error(let error):
                print("Fetching new release album categories failed. Error: \(error).")
            }
        })
        
    }
    
    private func fetchLatestAlbumsUnderCategorie(categoryId: String) {
        guard KKBOXAPIManager.shared.hasAccessToken else { return }
        
        _ = try? KKBOXAPIManager.shared.API.fetch(newReleasedAlbumsUnderCategory: categoryId, limit: 10, callback: { [weak self] result in
            switch result {
            case .success(let albums):
                guard let albumsInfo = albums.albums?.albums else { return }
                
                self?.albums = albumsInfo
                self?.collectionViewShouldReloadRelay.accept(())
            case .error(let error):
                print("Fetching new release albums under category failed. Error: \(error).")
            }
        })
    }

    func fetchFeaturedPlaylists() {
        guard playlistPageCount * lazyLoadingPageSize < playlistTotal,
              KKBOXAPIManager.shared.hasAccessToken else { return }
        
        _ = try? KKBOXAPIManager.shared.API.fetchFeaturedPlaylists(offset: playlistPageCount * lazyLoadingPageSize, limit: lazyLoadingPageSize, callback: { [weak self] result in
            switch result {
            case .success(let playListList):
                self?.playlistTotal = playListList.summary.total
                self?.playlists.append(contentsOf: playListList.playlists)
                self?.playlistPageCount += 1
                self?.tableViewShouldReloadRelay.accept(())
            case .error(let error):
                print("Fetching New Release Albums Categories Failed. Error: \(error).")
            }
        })
    }
}
