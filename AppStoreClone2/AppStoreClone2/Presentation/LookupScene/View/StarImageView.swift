//
//  StarImageView.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/09.
//

import UIKit

final class StarImageView: UIImageView {
    
    // MARK: - Nested Type
    
    enum StarKind {
        case filled, halfFilled, empty
        
        var systemNameOfImage: String {
            switch self {
            case .filled:
                return Text.filledStarImageName
            case .halfFilled:
                return Text.halfFilledStarImageName
            case .empty:
                return Text.emptyStarImageName
            }
        }
    }
    
    // MARK: - Initializers
    
    convenience init(kind: StarKind, tintColor: UIColor = .systemGray) {
        self.init(image: UIImage(systemName: kind.systemNameOfImage))
        configureUI(tintColor)
    }
    
    // MARK: - Methods
    
    private func configureUI(_ tintColor: UIColor) {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        self.tintColor = tintColor  // TODO: 확인
    }
    
}

// MARK: - NameSpaces

extension StarImageView {
    
    private enum Text {
        static let filledStarImageName: String = "star.fill"
        static let halfFilledStarImageName: String = "star.leadinghalf.filled"
        static let emptyStarImageName: String = "star"
    }
    
}
