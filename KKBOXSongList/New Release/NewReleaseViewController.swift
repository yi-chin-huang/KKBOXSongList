//
//  NewReleaseViewController.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/15.
//

import KKBOXOpenAPISwift
import UIKit
import RxCocoa
import RxSwift

class NewReleaseViewController: UIViewController {
    private let viewModel = NewReleaseViewModel()
    private lazy var latestAlbumLabel: UILabel = {
        let label = UILabel()
        label.text = "Latest Album Releases"
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var featuredPlaylistLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Featured Playlists"
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: NewAlbumsCollectionCell.imageWidth, height: NewAlbumsCollectionCell.imageHeight + NewAlbumsCollectionCell.titleHeight)
        flowLayout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellClass: NewAlbumsCollectionCell.self)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = PlaylistTableCell.imageHeight + 20
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: PlaylistTableCell.self)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        installLayout()
        setUpBindings()
    }
    
    private func setUpBindings() {
        viewModel.collectionViewShouldReload
            .emit { [weak self] _ in
                self?.collectionView.reloadData()
            }.disposed(by: disposedBag)
        
        viewModel.tableViewShouldReload
            .emit { [weak self] _ in
                self?.tableView.reloadData()
            }.disposed(by: disposedBag)

    }
    
    private func installLayout() {
        view.addSubview(latestAlbumLabel)
        NSLayoutConstraint.activate([
            latestAlbumLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            latestAlbumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: latestAlbumLabel.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.heightAnchor.constraint(equalToConstant: NewAlbumsCollectionCell.imageHeight + NewAlbumsCollectionCell.titleHeight)
        ])
        
        view.addSubview(featuredPlaylistLabel)
        NSLayoutConstraint.activate([
            featuredPlaylistLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            featuredPlaylistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: featuredPlaylistLabel.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension NewReleaseViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.albums.count > 10 ? 10 : viewModel.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewAlbumsCollectionCell.reuseIdentifier, for: indexPath) as? NewAlbumsCollectionCell else {
            return UICollectionViewCell()
        }
        let album = viewModel.albums[indexPath.row]
        cell.setContent(imageUrl: album.images.first?.url, title: album.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumInfo = viewModel.albums[indexPath.row]
        let playlistInfo = PlaylistInfo(type: .album, name: albumInfo.name, imageUrl: albumInfo.images.first?.url, id: albumInfo.ID, artist: albumInfo.artist, releaseDate: albumInfo.releaseDate)
        let playlistController = PlaylistViewController(playlistInfo: playlistInfo)
        navigationController?.pushViewController(playlistController, animated: true)
    }
}

extension NewReleaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableCell.reuseIdentifier, for: indexPath) as? PlaylistTableCell else {
            return UITableViewCell()
        }
        cell.setContent(playlistInfo: viewModel.playlists[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = viewModel.playlists[indexPath.row]
        let playlistInfo = PlaylistInfo(type: .playlist, name: playlist.title, imageUrl: playlist.images.first?.url, id: playlist.ID)
        let playlistController = PlaylistViewController(playlistInfo: playlistInfo)
        navigationController?.pushViewController(playlistController, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // User has scrolled to the bottom
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            viewModel.fetchFeaturedPlaylists()
        }
    }
}
