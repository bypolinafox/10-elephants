//
//  WideCellView.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 10.12.2021.
//

import UIKit

final class WideCellView: UICollectionViewCell {

    private enum Constants {
        static let labelGap: CGFloat = 10
        static let labelHeight: CGFloat = 20
        static let cornerRadius: CGFloat = 20
        static let titleFontSize: CGFloat = 20
        static let subtitleFontSize: CGFloat = 16
        static let imageBottomGap: CGFloat = -60
        static let shadowOpacity: Float = 0.2
        static let shadowRadius: CGFloat = 3
        static let shadowColor = UIColor.label.cgColor
        static let shadowOffset = CGSize(width: 0.0, height: 1.0)
    }

    lazy var titleLabel = makeTitleLabel()
    lazy var subtitleLabel = makeSubtitleLabel()
    lazy var imageView = makeImageView()
    lazy var containerView = makeContainerView()
    lazy var shadowLayer = makeShadowLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true

        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)

        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Constants.imageBottomGap),
            imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor)
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.labelGap),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Constants.cornerRadius)
        ])

        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.labelGap),
            subtitleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            subtitleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Constants.cornerRadius)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.insertSublayer(shadowLayer, at: 0)
    }
}

extension WideCellView {
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func makeSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: Constants.subtitleFontSize)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func makeImageView() -> UIImageView {
        let image = UIImageView()
        image.backgroundColor = .systemFill
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }

    private func makeContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func makeShadowLayer() -> CAShapeLayer {
        shadowLayer = CAShapeLayer()

        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: Constants.cornerRadius).cgPath
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowColor = Constants.shadowColor
        shadowLayer.shadowOffset = Constants.shadowOffset
        shadowLayer.shadowOpacity = Constants.shadowOpacity
        shadowLayer.shadowRadius = Constants.shadowRadius

        return shadowLayer
    }
}
