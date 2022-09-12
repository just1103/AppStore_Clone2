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
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.numberOfLines = 1
        return label
    }()
    private let starRatingStackView = StarRatingStackView()
    private let ratingContentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        label.numberOfLines = 1
        return label
    }()
    private var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemYellow, for: .normal)
        return button
    }()
    
    // MARK: - Initializers
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: Self.reuseIdentifier)
        configureUI()
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
        starRatingStackView.starImageViews = nil
        ratingContentLabel.text = nil
        favoriteButton.setImage(nil, for: .normal)
    }
    
    // MARK: - Methods
    // TODO: Cell-ViewModel 전달받도록 개선?
    func apply(appItem: AppItem) {
        appIconImageView.loadCachedImage(of: appItem.artworkURL100)
        titleLabel.text = appItem.trackName
        genreLabel.text = appItem.primaryGenreName
        starRatingStackView.apply(rating: appItem.averageUserRating)
        ratingContentLabel.text = "\(appItem.userRatingCount)"
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal) // TODO: Favorite 여부에 따라 star/star.fill로 분기 처리
    }

    private func configureUI() {
        [appIconImageView, contentStackView, ratingContentLabel, favoriteButton]
            .forEach { addSubview($0) }
        
        [titleLabel, genreLabel, starRatingStackView]
            .forEach { contentStackView.addArrangedSubview($0) }
        
        let safeArea = contentView.safeAreaLayoutGuide  // TODO: contentView 오류나면 view로 변경
        NSLayoutConstraint.activate([
            appIconImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            appIconImageView.heightAnchor.constraint(equalTo: appIconImageView.widthAnchor),
            appIconImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2),
            appIconImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            appIconImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            favoriteButton.topAnchor.constraint(equalTo: appIconImageView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            favoriteButton.bottomAnchor.constraint(equalTo: appIconImageView.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: appIconImageView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: appIconImageView.trailingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(equalTo: appIconImageView.bottomAnchor),
            
            ratingContentLabel.topAnchor.constraint(equalTo: starRatingStackView.topAnchor),
            ratingContentLabel.leadingAnchor.constraint(equalTo: starRatingStackView.trailingAnchor, constant: 5),
            ratingContentLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),
            ratingContentLabel.bottomAnchor.constraint(equalTo: starRatingStackView.bottomAnchor),
        ])
    }
    
}

// MARK: - NameSpace
extension SearchTableCell {
    private enum Text {
//        static let advisoryRatingTitleLabelText: String = "연령"
//        static let advisoryRatingSuffixLabelText: String = "세"
//        static let categoryTitleLabelText: String = "카테고리"
//        static let developerTitleLabelText: String = "개발자"
//        static let languageTitleLabelText: String = "언어"
//        static let developerImageSystemName: String = "person.crop.square"
//        static let shoppingCategoryImageSystemName: String = "cart"
    }
    
    private enum Design {
        static let appIconImageViewCornerRadius: CGFloat = 12
        static let appIconImageViewBorderWidth: CGFloat = 0.5
        static let appIconImageViewBorderColor: CGColor = UIColor.systemGray.cgColor

//        static let innerStackViewVerticalInset: CGFloat = 0
//        static let innerStackViewHorizontalInset: CGFloat = 10
//        static let innerStackViewSpacing: CGFloat = 8
        static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .caption2)
        static let titleLabelColor: UIColor = .systemGray2
        static let contentLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
        static let contentLabelColor: UIColor = .systemGray
        static let descriptionFont: UIFont = .preferredFont(forTextStyle: .footnote)
        static let descriptionColor: UIColor = .systemGray
    }
}
