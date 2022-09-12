//
//  StarRatingStackView.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/10.
//

import UIKit

class StarRatingStackView: UIStackView {
    
    // MARK: - Properties
    // ???: 외부에서 접근가능하게 해도 괜찮을까? (Cell prepareReuse에서 초기화하기 위한 목적)
//    weak var starImageViews: [StarImageView]?
    private let maxStarCount = 5
    
    // MARK: - Initializers
    
    convenience init() {
        self.init(frame: .zero)
        configureStackView()
    }
    
    // FIXME: 제대로 deinit되지 않는 문제 발생
//    deinit {
//        starImageViews?.forEach { removeArrangedSubview($0) }
//    }
    
    // MARK: - Methods
    
    func apply(rating: Double, tintColor: UIColor = .systemGray) {
        let starImageViews = configureStarImageView(rating, tintColor)
        configureHierarchy(with: starImageViews)
    }
    
    private func configureStarImageView(_ rating: Double, _ tintColor: UIColor) -> [StarImageView] {
        let starCountByKind = calculateStarCountByKind(with: rating)
        
        var starImageViews = [StarImageView]()
        starImageViews += (0..<starCountByKind.filled)
            .map { _ in StarImageView(kind: .filled, tintColor: tintColor) }
        starImageViews += (0..<starCountByKind.halfFilled)
            .map { _ in StarImageView(kind: .halfFilled, tintColor: tintColor) }
        starImageViews += (0..<starCountByKind.empty)
            .map { _ in StarImageView(kind: .empty, tintColor: tintColor) }
        
        return starImageViews
    }
    
    private func calculateStarCountByKind(with rating: Double) -> (filled: Int, halfFilled: Int, empty: Int) {
        let filledStarCount = Int(rating)

        let remainder = rating.truncatingRemainder(dividingBy: 1)
        let halfFilledStarCount = remainder >= 0.5 ? 1 : 0
        
        let emptyStarCount = maxStarCount - filledStarCount - halfFilledStarCount
        
        return (filledStarCount, halfFilledStarCount, emptyStarCount)
    }
    
    private func configureHierarchy(with starImageViews: [StarImageView]?) {
        starImageViews?.forEach { addArrangedSubview($0) }
    }

    private func configureStackView() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = -1
    }
    
}
