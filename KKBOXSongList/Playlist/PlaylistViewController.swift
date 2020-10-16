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
//    private let playlistImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .lightGray
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
//        tableView.rowHeight = TrackTableCell.imageHeight + 20
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: TrackTableCell.self)
        tableView.register(cellClass: PlaylistCoverCell.self)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let disposedBag = DisposeBag()
    
    init(type: PlaylistType, playlist: KKPlaylistInfo) {
        viewModel = PlaylistViewModel(type: type, id: playlist.ID)
        self.name = playlist.title
        self.imageUrl = playlist.images.first?.url
        
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
//        if let url = imageUrl {
//            playlistImageView.loadImage(with: url)
//        }
        installLayout()
        setUpBindings()
    }
    
    private func setUpBindings() {
        viewModel.tableViewShouldReload
            .emit { [weak self] _ in
                self?.tableView.reloadData()
            }.disposed(by: disposedBag)

    }
    
    private func installLayout() {
//        view.addSubview(playlistImageView)
//        NSLayoutConstraint.activate([
//            playlistImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            playlistImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            playlistImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            playlistImageView.heightAnchor.constraint(equalToConstant: 120)
//        ])
        
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
        return viewModel.tracksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistCoverCell.reuseIdentifier, for: indexPath) as? PlaylistCoverCell else {
                return UITableViewCell()
            }
//            cell.setIm
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableCell.reuseIdentifier, for: indexPath) as? TrackTableCell else {
                return UITableViewCell()
            }
            cell.setContent(trackInfo: viewModel.tracksList[indexPath.row])
            return cell
        }
    }
}
