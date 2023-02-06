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
        
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        self.lbDeveloper = lbDeveloper
        self.lbTitle = lbTitle
        self.lbReleaseDate = lbReleaseDate
        self.lbRate = lbRate
        self.lbCount = lbCount
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
        view.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let url = URL(string: "https://media.rawg.io/media/games/328/3283617cb7d75d67257fc58339188742.jpg")
        view.sd_setImage(with: url)
        return view
    }
    
    func generateTitleLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.textColor = .darkText
        view.text = "Portal 2"
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
    
    func generateDeveloperLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .light)
        view.textColor = .darkText.withAlphaComponent(0.7)
        view.text = "Rockstar Games"
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
    
    func generateReleaseLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.textColor = .darkText.withAlphaComponent(0.6)
        view.text = "Release date 2021-08-20"
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
    
    func generateSubtitleDesign() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .light)
        view.textColor = .darkText.withAlphaComponent(0.7)
        view.text = "Release date 2021-08-20"
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }

    func generateContentLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textColor = .darkText
        var test = "<p>Portal 2 is a first-person puzzle game developed by Valve Corporation and released on April 19, 2011 on Steam, PS3 and Xbox 360. It was published by Valve Corporation in digital form and by Electronic Arts in physical form. </p>\n<p>Its plot directly follows the first game&#39;s, taking place in the Half-Life universe. You play as Chell, a test subject in a research facility formerly ran by the company Aperture Science, but taken over by an evil AI that turned upon its creators, GladOS. After defeating GladOS at the end of the first game but failing to escape the facility, Chell is woken up from a stasis chamber by an AI personality core, Wheatley, as the unkempt complex is falling apart. As the two attempt to navigate through the ruins and escape, they stumble upon GladOS, and accidentally re-activate her...</p>\n<p>Portal 2&#39;s core mechanics are very similar to the first game&#39;s ; the player must make their way through several test chambers which involve puzzles. For this purpose, they possess a Portal Gun, a weapon capable of creating teleportation portals on white surfaces. This seemingly simple mechanic and its subtleties coupled with the many different puzzle elements that can appear in puzzles allows the game to be easy to start playing, yet still feature profound gameplay. The sequel adds several new puzzle elements, such as gel that can render surfaces bouncy or allow you to accelerate when running on them.</p>\n<p>The game is often praised for its gameplay, its memorable dialogue and writing and its aesthetic. Both games in the series are responsible for inspiring most puzzle games succeeding them, particularly first-person puzzle games. The series, its characters and even its items such as the portal gun and the companion cube have become a cultural icon within gaming communities.</p>\n<p>Portal 2 also features a co-op mode where two players take on the roles of robots being led through tests by GladOS, as well as an in-depth level editor.</p>"
        let str = test.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        view.text = str
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }
}

// MARK: VIEW
private extension Presentation.UiKit.GameDetailViewController {
    func initView() {
        lbRate?.attributedText = generateRateLabelText(rate: "4.5")
        lbCount?.attributedText = generateCountLabelText(count: "200")
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
