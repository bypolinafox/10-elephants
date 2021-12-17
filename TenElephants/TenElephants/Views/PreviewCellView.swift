//
//  PreviewCellView.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 13.12.2021.
//

import Foundation
import UIKit
import Combine

final class PreviewCellView: UICollectionViewCell {
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?

    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var containerView = makeContainerView()
    lazy var shadowLayer = makeShadowLayer()
    lazy var indicator = makeActivityIndicator()

    private enum Constants {
        static let titleFontSize: CGFloat = 18
        static let cornerRadius: CGFloat = 20
        static let imCornRadius: CGFloat = 15
        static let labelGap: CGFloat = 10
        static let imageGap: CGFloat = 10
        static let shadowOpacity: Float = 0.2
        static let shadowRadius: CGFloat = 3
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset = CGSize(width: 0.0, height: 1.0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = Constants.cornerRadius
        containerView.addSubview(titleLabel)
        containerView.addSubview(imageView)
        containerView.addSubview(indicator)
        contentView.clipsToBounds = true
        contentView.addSubview(containerView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.insertSublayer(shadowLayer, at: 0)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        animator?.stopAnimation(true)
        cancellable?.cancel()
    }
}

extension PreviewCellView {
    func makeTitleLabel() -> UILabel {
        let label = UILabel(
            frame: CGRect(
                x: self.frame.width / 2 + Constants.labelGap, y: 0,
                width: self.frame.width / 2 - 2 * Constants.labelGap,
                height: self.frame.height
            )
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        return label
    }

    private func makeImageView() -> UIImageView {
        let image = UIImageView(
            frame: CGRect(
                x: Constants.imageGap, y: Constants.imageGap,
                width: self.frame.width / 2 - 2 * Constants.imageGap,
                height: self.frame.height - 2 * Constants.imageGap
            )
        )
        image.backgroundColor = .systemFill
        image.layer.cornerRadius = Constants.imCornRadius
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }

    func makeContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func makeShadowLayer() -> CAShapeLayer {
        shadowLayer = CAShapeLayer()

        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: Constants.cornerRadius)
            .cgPath
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowColor = Constants.shadowColor
        shadowLayer.shadowOffset = Constants.shadowOffset
        shadowLayer.shadowOpacity = Constants.shadowOpacity
        shadowLayer.shadowRadius = Constants.shadowRadius

        return shadowLayer
    }

    func makeActivityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = CGPoint(
            x: 0.75 * self.contentView.frame.width,
            y: self.contentView.center.y
        )
        return indicator
    }
}

extension PreviewCellView {

    private func showImage(image: UIImage?) {
        imageView.alpha = 0.0
        animator?.stopAnimation(false)
        imageView.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.imageView.alpha = 1.0
        })
    }

    func configure(
        titleText: String?,
        thumbnailLink: String? = nil,
        imageLoader: ImageLoader? = nil
    ) {
        self.titleLabel.text = titleText
        guard let link = thumbnailLink, let imageLoader = imageLoader else {
            return
        }
        cancellable = imageLoader.loadImage(thumbnailLink: link).sink { [unowned self] image in
            self.showImage(image: image)
        }
    }
}
