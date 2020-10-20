//
//  PlaylistViewController.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/16.
//

import KKBOXOpenAPISwift
import UIKit
import RxCocoa
import RxSwift

class PlaylistViewController: UIViewController {
    private let viewModel: PlaylistViewModel
    private let name: String
    private let imageUrl: URL?
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: TrackTableCell.self)
        tableView.register(cellClass: PlaylistCoverCell.self)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let disposedBag = DisposeBag()
    
    init(playlistInfo: PlaylistInfo) {
        viewModel = PlaylistViewModel(playlistInfo: playlistInfo)
        name = playlistInfo.name
        imageUrl = playlistInfo.imageUrl
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        setUpBindings()
        installLayout()
    }
    
    private func setUpBindings() {
        viewModel.tableViewShouldReload
            .emit { [weak self] _ in
                self?.tableView.reloadData()
            }.disposed(by: disposedBag)
    }
    
    private func installLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15)
        ])
    }
}


extension PlaylistViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tracksList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistCoverCell.reuseIdentifier, for: indexPath) as? PlaylistCoverCell else {
                return UITableViewCell()
            }
            if let url = imageUrl{
                cell.setImage(url: url)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableCell.reuseIdentifier, for: indexPath) as? TrackTableCell else {
                return UITableViewCell()
            }
            cell.setContent(trackInfo: viewModel.tracksList[indexPath.row - 1])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return PlaylistCoverCell.height + 20
        } else {
            return TrackTableCell.imageHeight + 20
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0,
              let trackUrl = viewModel.tracksList[indexPath.row - 1].trackUrl else {
            return
        }
        
        let webViewController = SongWebViewController(url: trackUrl)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

struct PlaylistInfo {
    let type: PlaylistType
    let name: String
    let imageUrl: URL?
    let id: String
    let artist: KKArtistInfo?
    let releaseDate: String?
    init(type: PlaylistType, name: String, imageUrl: URL?, id: String, artist: KKArtistInfo? = nil, releaseDate: String? = nil) {
        self.type = type
        self.name = name
        self.imageUrl = imageUrl
        self.id = id
        self.artist = artist
        self.releaseDate = releaseDate
    }
}
