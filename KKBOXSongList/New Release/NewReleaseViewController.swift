//
//  ViewController.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/15.
//

import UIKit
import RxCocoa
import RxSwift

class NewReleaseViewController: UIViewController {
    private let viewModel = NewReleaseViewModel()
    private let latestAlbumLabel: UILabel = {
        let label = UILabel()
        label.text = "Latest Album Releases"
        label.textColor = .kkbox
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    private let featuredPlaylistLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Featured Playlists"
        label.textColor = .kkbox
        label.font = .boldSystemFont(ofSize: 14)
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
        return collectionView
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = PlaylistsTableCell.imageHeight + 20
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: PlaylistsTableCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()
    private let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        installConstraits()
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
    
    private func installConstraits() {
        view.addSubview(latestAlbumLabel)
        latestAlbumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            latestAlbumLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            latestAlbumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: latestAlbumLabel.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.heightAnchor.constraint(equalToConstant: NewAlbumsCollectionCell.imageHeight + NewAlbumsCollectionCell.titleHeight)
        ])
        
        view.addSubview(featuredPlaylistLabel)
        featuredPlaylistLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            featuredPlaylistLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            featuredPlaylistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        cell.delegate = self
        cell.setContent(imageUrl: album.images.first?.url, title: album.name, indexPath: indexPath)
        return cell
    }
}

extension NewReleaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistsTableCell.reuseIdentifier, for: indexPath) as? PlaylistsTableCell else {
            return UITableViewCell()
        }
        let playlist = viewModel.playlists[indexPath.row]
        cell.setContent(imageUrl: playlist.images.first?.url, title: playlist.title, owner: playlist.owner.name, lastUpdateDate: playlist.lastUpdateDate)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // User has scrolled to the bottom
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            viewModel.fetchFeaturedPlaylists()
        }
    }
}

extension NewReleaseViewController: NewAlbumsCollectionCellDelegate {
    func reload(indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}
