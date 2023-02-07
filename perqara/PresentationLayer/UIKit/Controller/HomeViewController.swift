//
//  HomeViewController.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

// MARK: LIFECYCLE AND CALLBACK
extension Presentation.UiKit {
    class HomeViewController: UIViewController {
        // MARK: Outlets
        private var vwContainer: UIView?
        private var sbContent: UISearchBar?
        private var tvContent: UITableView?
        private var data: [Domain.GameEntity] = []
        private var lastPage = 1
        private var searchString: String?
        private var vmBag = DisposeBag()
        private var isInit = true
        
        private var viewModel: HomeViewModel

        init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: HomeViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            initDesign()
            initViews()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            subscribeViewModel()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            if isInit {
                viewModel.getGameList(page: lastPage, search: searchString)
            }
            
            isInit = false
        }
        
        private func subscribeViewModel() {
            viewModel.lastPage = lastPage
            viewModel.errors
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] error in
                        guard let self = self else {
                            return
                        }
                        self.handleError(error)
                    }
                )
                .disposed(by: vmBag)
            viewModel
                .gameLists
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] games in
                        guard let self = self else {
                            return
                        }
                        if self.data.isEmpty || self.lastPage == 1 {
                            self.initGamesData(games)
                        } else {
                            self.appendGamesData(games)
                        }
                    }
                )
                .disposed(by: vmBag)
        }
    }
}

// MARK: Function
private extension Presentation.UiKit.HomeViewController {
    func initGamesData(_ datas: [Domain.GameEntity]) {
        self.data =  datas
        tvContent?.reloadData()
    }

    func appendGamesData(_ datas: [Domain.GameEntity]) {
        appendTable(datas)
    }
    
    func requestLoadMore() {
        lastPage += 1
        viewModel.getGameList(page: lastPage, search: searchString)
    }
    
    func searchGame(_ search: String) {
        lastPage = 1
        searchString = search
        viewModel.getGameList(page: lastPage, search: searchString)
    }
    
    func appendTable(
        _ datas: [Domain.GameEntity]
    ) {
        data.append(contentsOf: datas)
        tvContent?.reloadData()
        tvContent?.dequeueReusableCell(withIdentifier: GameTableCell.identifier)
    }
}

// MARK: DESIGN
private extension Presentation.UiKit.HomeViewController {
    private func initDesign() {
        setupBaseView()
        
        let vwContainer = generateViewForContainerDesign()
        let sbContent = generateSearchBarDesign()
        let tvContent = generateTableView()
        
        view.addSubview(vwContainer)
        vwContainer.addSubview(sbContent)
        vwContainer.addSubview(tvContent)
        
        vwContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        sbContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        tvContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(sbContent.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        self.vwContainer = vwContainer
        self.sbContent = sbContent
        self.tvContent = tvContent
    }
    
    func setupBaseView() {
        view.backgroundColor = .white
    }
    
    func generateViewForContainerDesign() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }
    
    func generateSearchBarDesign() -> UISearchBar {
        let view = UISearchBar(frame: .zero)
        view.searchBarStyle = UISearchBar.Style.default
        view.placeholder = " Search..."
        view.sizeToFit()
        view.isTranslucent = true
        view.delegate = self
        return view
    }
    
    func generateTableView() -> UITableView {
        let view = UITableView(frame: .zero,style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        return view
    }
}

// MARK: View
private extension Presentation.UiKit.HomeViewController {
    func initViews() {
        initTableView()
    }
    
    func initTableView() {
        tvContent?.register(
            GameTableCell.self,
                forCellReuseIdentifier: GameTableCell.identifier
        )
        self.tvContent?.delegate = self
        self.tvContent?.dataSource = self
        tvContent?.rowHeight = UITableView.automaticDimension
        tvContent?.estimatedRowHeight = 600
    }
}

// MARK: Search Bar
extension Presentation.UiKit.HomeViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.searchGame(textSearched)
        }
    }
}

// MARK: TABLE DELEGATE
extension Presentation.UiKit.HomeViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: GameTableCell.identifier, for: indexPath
        ) as? GameTableCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.updateUI(data: data[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = (UIApplication.shared.delegate as? ProvideViewControllerResolver)?.vcResolver.instantiateGameDetailController().get() {
            vc.gameId = String(data[indexPath.row].id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let table = tvContent else {
            return
        }
        let y = scrollView.contentOffset.y/(scrollView.contentSize.height - scrollView.frame.size.height)
        let relativeHeight = 1 - (table.rowHeight / (scrollView.contentSize.height - scrollView.frame.size.height))
        if y >= relativeHeight{
            requestLoadMore()
        }
    }
}
