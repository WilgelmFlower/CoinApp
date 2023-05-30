import UIKit
import SnapKit

final class DetailsViewController: UIViewController {

    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .systemGray2

        return line
    }()

    private let separatorLineSecond: UIView = {
        let line = UIView()
        line.backgroundColor = .systemGray2

        return line
    }()

    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalCentering

        return stack
    }()

    private let marketStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical

        return stack
    }()

    private let supplyStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical

        return stack
    }()

    private let volumeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical

        return stack
    }()

    let titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = .systemFont(ofSize: 24)

        return title
    }()

    let percentLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14)

        return title
    }()

    private let marketTitle: UILabel = {
        let title = UILabel()
        title.text = "Market Cap"
        title.font = .systemFont(ofSize: 12)
        title.textColor = .systemGray

        return title
    }()

    let marketValue: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16)
        title.textColor = .white

        return title
    }()

    private let supplyTitle: UILabel = {
        let title = UILabel()
        title.text = "Supply"
        title.font = .systemFont(ofSize: 12)
        title.textColor = .systemGray

        return title
    }()

    let supplyValue: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16)
        title.textColor = .white

        return title
    }()

    private let volumeTitle: UILabel = {
        let title = UILabel()
        title.text = "Volume 24 Hr"
        title.font = .systemFont(ofSize: 12)
        title.textColor = .systemGray

        return title
    }()

    let volumeValue: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16)
        title.textColor = .white

        return title
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "moon")!)
        setup()
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func setup() {
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(marketStackView)
        horizontalStackView.addArrangedSubview(separatorLine)
        horizontalStackView.addArrangedSubview(supplyStackView)
        horizontalStackView.addArrangedSubview(separatorLineSecond)
        horizontalStackView.addArrangedSubview(volumeStackView)
        view.addSubview(titleLabel)
        view.addSubview(percentLabel)
        marketStackView.addArrangedSubview(marketTitle)
        marketStackView.addArrangedSubview(marketValue)
        supplyStackView.addArrangedSubview(supplyTitle)
        supplyStackView.addArrangedSubview(supplyValue)
        volumeStackView.addArrangedSubview(volumeTitle)
        volumeStackView.addArrangedSubview(volumeValue)

        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(150)
        }

        percentLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(10)
            $0.bottom.equalTo(supplyStackView.snp.top).offset(-30)
        }

        horizontalStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.right.equalToSuperview().offset(-20)
            $0.left.equalToSuperview().offset(20)
        }

        separatorLine.snp.makeConstraints {
            $0.width.equalTo(1)
        }

        separatorLineSecond.snp.makeConstraints {
            $0.width.equalTo(1)
        }
    }
}
