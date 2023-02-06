//
//  HomeViewController.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import UIKit
import SnapKit

// MARK: LIFECYCLE AND CALLBACK
extension Presentation.UiKit {
    class HomeViewController: UIViewController {
        // MARK: Outlets
        private var vwContainer: UIView?
        private var sbContent: UISearchBar?
        private var tvContent: UITableView?

        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        print(textSearched)
    }
}

// MARK: TABLE DELEGATE
extension Presentation.UiKit.HomeViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: GameTableCell.identifier, for: indexPath
        ) as? GameTableCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.updateUI()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: GOTO DETAIL SCREEN
        let vc = Presentation.UiKit.GameDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let table = tvContent else {
            return
        }
        let y = scrollView.contentOffset.y/(scrollView.contentSize.height - scrollView.frame.size.height)
        let relativeHeight = 1 - (table.rowHeight / (scrollView.contentSize.height - scrollView.frame.size.height))
        if y >= relativeHeight{
            // TODO: Add Request Load More Function Here
        }
    }
}
