//
//  PlaylistViewController.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/16.
//

import UIKit
import RxCocoa
import RxSwift

class PlaylistViewController: UIViewController {
    private let viewModel = PlaylistViewModel()
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = PlaylistsTableCell.imageHeight + 20
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: PlaylistsTableCell.self)
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
        viewModel.tableViewShouldReload
            .emit { [weak self] _ in
                self?.tableView.reloadData()
            }.disposed(by: disposedBag)

    }
    
    private func installLayout() {
        view.addSubview(playlistImageView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: playlistImageView.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15)
        ])
    }
}


extension PlaylistViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trackslist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistsTableCell.reuseIdentifier, for: indexPath) as? PlaylistsTableCell else {
            return UITableViewCell()
        }
        let playlist = viewModel.trackslist[indexPath.row]
//        cell.setContent(imageUrl: playlist.images.first?.url, title: playlist.title, owner: playlist.owner.name, lastUpdateDate: playlist.lastUpdateDate)
        return cell
    }
}
