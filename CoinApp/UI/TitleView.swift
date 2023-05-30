import UIKit
import SnapKit

class TitleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 130
        stack.distribution = .equalSpacing
        
        return stack
    }()

    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Trending Coins"
        title.textColor = .white
        title.font = .boldSystemFont(ofSize: 24)

        return title
    }()

    private(set) lazy var searchButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white

        return button
    }()

    private func setup() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(searchButton)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
