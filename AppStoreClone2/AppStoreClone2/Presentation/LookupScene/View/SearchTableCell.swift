//
//  SearchTableCell.swift
//  AppStoreClone2
//
//  Created by Hyoju Son on 2022/09/12.
//

import UIKit

final class SearchTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Design.appIconImageViewCornerRadius
        imageView.layer.borderWidth = Design.appIconImageViewBorderWidth
        imageView.layer.borderColor = Design.appIconImageViewBorderColor
        imageView.clipsToBounds = true
        return imageView
    }()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelColor
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Design.genreLabelFont
        label.textColor = Design.genreLabelColor
        label.numberOfLines = 1
        return label
    }()
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    private let starRatingStackView = StarRatingStackView()
    private let ratingCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Design.ratingCountLabelFont
        label.textColor = Design.ratingCountLabelColor
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    private var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemYellow
        return button
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }
    
    // MARK: - Lifecycle Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        appIconImageView.image = nil
        titleLabel.text = nil
        genreLabel.text = nil
//        starRatingStackView.starImageViews = nil  // FIXME: 초기화되지 않는 문제
        ratingCountLabel.text = nil
        favoriteButton.setImage(nil, for: .normal)
    }
    
    // MARK: - Methods
    // TODO: Cell-ViewModel 전달받도록 개선?
    func apply(appItem: AppItem) {
        appIconImageView.loadCachedImage(of: appItem.artworkURL100)
        titleLabel.text = appItem.trackName
        genreLabel.text = appItem.primaryGenreName
        starRatingStackView.apply(rating: appItem.averageUserRating)
        ratingCountLabel.text = "\(appItem.userRatingCount)"
        let starImage = UIImage(systemName: "star")
        favoriteButton.setImage(starImage, for: .normal) // TODO: Favorite 여부에 따라 star/star.fill로 분기 처리
    }

    private func configureUI() {
        [appIconImageView, contentStackView, favoriteButton].forEach { addSubview($0) }
        [titleLabel, genreLabel, ratingStackView].forEach { contentStackView.addArrangedSubview($0) }
        [starRatingStackView, ratingCountLabel].forEach { ratingStackView.addArrangedSubview($0) }
        
        let safeArea = safeAreaLayoutGuide
//        let safeArea = contentView.safeAreaLayoutGuide  // ???: 왜 오류나는지 확인
        NSLayoutConstraint.activate([
            appIconImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            appIconImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.18),
            appIconImageView.heightAnchor.constraint(equalTo: appIconImageView.widthAnchor),
            appIconImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            appIconImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            
            favoriteButton.topAnchor.constraint(equalTo: appIconImageView.topAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.1),
//            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            favoriteButton.bottomAnchor.constraint(equalTo: appIconImageView.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: appIconImageView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: appIconImageView.trailingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(equalTo: appIconImageView.bottomAnchor),
            
            ratingCountLabel.centerYAnchor.constraint(equalTo: ratingStackView.centerYAnchor),
        ])
    }
    
}

// MARK: - NameSpace
extension SearchTableCell {
    private enum Design {
        static let appIconImageViewCornerRadius: CGFloat = 12
        static let appIconImageViewBorderWidth: CGFloat = 0.5
        static let appIconImageViewBorderColor: CGColor = UIColor.systemGray.cgColor
        static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
        static let titleLabelColor: UIColor = .label
        static let genreLabelFont: UIFont = .preferredFont(forTextStyle: .body)
        static let genreLabelColor: UIColor = .systemGray
        static let ratingCountLabelFont: UIFont = .preferredFont(forTextStyle: .body)
        static let ratingCountLabelColor: UIColor = .systemGray
    }
}
