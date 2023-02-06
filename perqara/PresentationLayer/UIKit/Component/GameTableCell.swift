//
//  GameTableCell.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class GameTableCell: UITableViewCell {
    public static let identifier: String = "GameTableCell"
    private var vwContainer: UIView?
    private var ivContent: UIImageView?
    private var lbTitle: UILabel?
    private var lbReleaseDate: UILabel?
    private var lbRate: UILabel?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initDesign()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initDesign()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateUI() {
        
        lbRate?.attributedText = generateRateLabelText(rate: "4.3")
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
}

// MARK: UIKIT
private extension GameTableCell {
    func initDesign() {
        setupBaseView()
        let vwContainer = generateContainer()
        let ivContent = generateContentImageView()
        let lbTitle = generateTitleLabel()
        let lbReleaseDate = generateSubtitleDesign()
        let lbRate = generateSubtitleDesign()
        
        contentView.addSubview(vwContainer)
        vwContainer.addSubview(ivContent)
        vwContainer.addSubview(lbTitle)
        vwContainer.addSubview(lbReleaseDate)
        vwContainer.addSubview(lbRate)
        
        vwContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }

        ivContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(150)
            make.height
                .equalTo(ivContent.snp.width)
                .multipliedBy(3.0 / 4.0)
                .priority(.high)
        }
        
        lbTitle.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.leading.equalTo(ivContent.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
            make.top.equalTo(ivContent).offset(2)
        }
        
        lbReleaseDate.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.leading.equalTo(lbTitle)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.top.equalTo(lbTitle.snp.bottom).offset(2)
        }
        
        lbRate.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.leading.equalTo(lbTitle)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.top.equalTo(lbReleaseDate.snp.bottom).offset(2)
        }
        
        self.vwContainer = vwContainer
        self.ivContent = ivContent
        self.lbTitle = lbTitle
        self.lbReleaseDate = lbReleaseDate
        self.lbRate = lbRate
    }
    
    func setupBaseView() {
        self.contentView.backgroundColor = .clear
    }
    
    func generateContainer() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        
        return view
    }
    
    func generateTitleLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        view.textColor = .darkText
        view.text = "Portal 2"
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
    
    func generateContentImageView() -> UIImageView {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let url = URL(string: "https://media.rawg.io/media/games/328/3283617cb7d75d67257fc58339188742.jpg")
        view.sd_setImage(with: url)
        view.layer.cornerRadius = 10
        return view
    }
}
