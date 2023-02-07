//
//  GameDetailViewController.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import RxSwift

// MARK: LIFECYCLE AND CALLBACK
extension Presentation.UiKit {
    class GameDetailViewController: UIViewController {
        private var vwContainer: UIView?
        private var svContent: UIView?
        private var ivContent: UIImageView?
        private var lbDeveloper: UILabel?
        private var lbTitle: UILabel?
        private var lbReleaseDate: UILabel?
        private var lbRate: UILabel?
        private var lbCount: UILabel?
        private var lbContent: UILabel?
        
        private var vmBag = DisposeBag()

        private var viewModel: GameDetailViewModel
        private var data: Domain.GameEntity?
        
        var gameId: String?
        
        init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: GameDetailViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            initDesign()
            initView()
        }
        
        //This method will call when you press button.
        @objc
        func favoriteButtonTapped() {
            if let data = data,
               !data.isFavorite {
                self.data?.isFavorite.toggle()
                viewModel.insetGameToLocal(game: data)
                reloadView()
            } else {
                self.data?.isFavorite.toggle()
                viewModel.deletaLocalGame(byId: gameId ?? "")
                reloadView()
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            subscribeViewModel()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            if let gameId = gameId {
                showActivityIndicator()
                viewModel.getGameDetail(byId: gameId)
            }
        }
        
        private func subscribeViewModel() {
            viewModel.errors
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] error in
                        guard let self = self else {
                            return
                        }
                        self.hideActivityIndicator()
                        self.handleError(error)
                    }
                )
                .disposed(by: vmBag)
            viewModel
                .gameData
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] game in
                        guard let self = self else {
                            return
                        }
                        self.hideActivityIndicator()
                        self.populateData(game)
                    }
                )
                .disposed(by: vmBag)
        }
    }
}

// MARK: Function
private extension Presentation.UiKit.GameDetailViewController {
    func populateData(_ data: Domain.GameEntity) {
        self.data = data
        lbRate?.attributedText = generateRateLabelText(rate: data.rating)
        let url = URL(string: data.backgroundImage)
        ivContent?.sd_setImage(with: url)
        lbTitle?.text = data.name
        lbReleaseDate?.text = "Release date \(data.released)"
        lbCount?.attributedText = generateCountLabelText(count: data.suggestionsCount)
        let textDescription = data.description
        let str = textDescription.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        lbContent?.text = str
        reloadView()
    }
    
    func reloadView() {
        initView()
    }
}

// MARK: UIBUILDER
private extension Presentation.UiKit.GameDetailViewController {
    func initDesign() {
        setupBaseView()
        let svContent = generateScrollView()
        let vwContainer = generateContainerView()
        let ivContent = generateContentImageView()
        let lbDeveloper = generateDeveloperLabel()
        let lbTitle = generateTitleLabel()
        let lbReleaseDate = generateReleaseLabel()
        let lbRate = generateSubtitleDesign()
        let lbCount = generateSubtitleDesign()
        let lbContent = generateContentLabel()
        
        view.addSubview(svContent)
        svContent.addSubview(vwContainer)
        vwContainer.addSubview(ivContent)
        vwContainer.addSubview(lbDeveloper)
        vwContainer.addSubview(lbTitle)
        vwContainer.addSubview(lbReleaseDate)
        vwContainer.addSubview(lbRate)
        vwContainer.addSubview(lbCount)
        vwContainer.addSubview(lbContent)
        
        svContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        vwContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        ivContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        lbDeveloper.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(ivContent.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        lbTitle.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbDeveloper.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        lbReleaseDate.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        lbRate.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbReleaseDate.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        lbCount.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbRate)
            make.leading.equalTo(lbRate.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        lbContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbRate.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        self.vwContainer = vwContainer
        self.ivContent = ivContent
        self.lbDeveloper = lbDeveloper
        self.lbTitle = lbTitle
        self.lbReleaseDate = lbReleaseDate
        self.lbRate = lbRate
        self.lbCount = lbCount
        self.lbContent = lbContent
    }
    
    func setupBaseView() {
        view.backgroundColor = .white
        self.navigationItem.title = "Detail"
    }
    
    func generateContainerView() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func generateScrollView() -> UIScrollView {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        view.bounces = true
        return view
    }
    
    func generateContentImageView() -> UIImageView {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func generateTitleLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.textColor = .darkText
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
    
    func generateDeveloperLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .light)
        view.textColor = .darkText.withAlphaComponent(0.7)
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
    
    func generateReleaseLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.textColor = .darkText.withAlphaComponent(0.6)
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
    
    func generateSubtitleDesign() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .light)
        view.textColor = .darkText.withAlphaComponent(0.7)
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }

    func generateContentLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textColor = .darkText
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
}

// MARK: VIEW
private extension Presentation.UiKit.GameDetailViewController {
    func initView() {
        initNavigationRightButton()
    }
    
    func initNavigationRightButton() {
        if let data = data {
            //create a new button
            let button = UIButton(type: .custom)
            //set image for button
            if data.isFavorite {
                button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                button.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            
            //add function for button
            button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
            //set frame
            button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)

            let barButton = UIBarButtonItem(customView: button)
            //assign button to navigationbar
            
            self.navigationItem.rightBarButtonItem = barButton
        }
    }
    
    
    private func generateRateLabelText(rate: String) -> NSMutableAttributedString {
        let fullText = NSMutableAttributedString(string: "")

        let checkIcon = NSTextAttachment()
        checkIcon.image = UIImage(systemName: "star.fill")?.withTintColor(.orange)

        let labelFont = UIFont.systemFont(ofSize: 12, weight: .light)
        let imageSize = CGSize(width: 12, height: 12)
        checkIcon.bounds = CGRect(
            x: 0,
            y: (labelFont.capHeight - imageSize.height) / 2,
            width: imageSize.width,
            height: imageSize.height
        )

        let checkedString = NSAttributedString(attachment: checkIcon)

        fullText.append(checkedString)
        fullText.append(NSAttributedString(string: "  "))
        fullText.append(NSAttributedString(string: rate))
        return fullText
    }
    
    private func generateCountLabelText(count: String) -> NSMutableAttributedString {
        let fullText = NSMutableAttributedString(string: "  ")

        let checkIcon = NSTextAttachment()
        checkIcon.image = UIImage(systemName: "gamecontroller.fill")

        let labelFont = UIFont.systemFont(ofSize: 12, weight: .light)
        let imageSize = CGSize(width: 16, height: 12)
        checkIcon.bounds = CGRect(
            x: 0,
            y: (labelFont.capHeight - imageSize.height) / 2,
            width: imageSize.width,
            height: imageSize.height
        )

        let checkedString = NSAttributedString(attachment: checkIcon)

        fullText.append(checkedString)
        fullText.append(NSAttributedString(string: "  "))
        fullText.append(NSAttributedString(string: count))
        fullText.append(NSAttributedString(string: " played"))
        return fullText
    }
}
