import UIKit

class CoinCell: UITableViewCell {
    
    static let identifier = String(describing: CoinCell.self)
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let sumStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private(set) lazy var coinImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        
        return image
    }()
    
    private let fullNameCoin: UILabel = {
        let title = UILabel()
        title.textColor = .white
        
        return title
    }()
    
    private let shortNameCoin: UILabel = {
        let title = UILabel()
        title.textColor = .systemGray
        
        return title
    }()
    
    private let totalSum: UILabel = {
        let title = UILabel()
        title.textColor = .white
        
        return title
    }()
    
    private let percentPer: UILabel = {
        let title = UILabel()
        
        return title
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        contentView.addSubview(coinImage)
        contentView.addSubview(nameStackView)
        nameStackView.addArrangedSubview(fullNameCoin)
        nameStackView.addArrangedSubview(shortNameCoin)
        addSubview(sumStackView)
        sumStackView.addArrangedSubview(totalSum)
        sumStackView.addArrangedSubview(percentPer)
        
        coinImage.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.leftMargin)
            $0.centerY.equalTo(contentView)
            $0.width.height.equalTo(60)
        }
        
        nameStackView.snp.makeConstraints {
            $0.left.equalTo(coinImage.snp.right).offset(10)
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
        
        sumStackView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
    
    func configure(fullName: String, shortName: String, totalSum: String, percentPer: String) {
        self.fullNameCoin.text = fullName
        self.shortNameCoin.text = shortName
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        if let sum = Double(totalSum), let formattedSum = formatter.string(from: NSNumber(value: sum)) {
            self.totalSum.text = formattedSum
        } else {
            self.totalSum.text = totalSum
        }
        
        if let percent = Double(percentPer) {
            let formattedPercent = String(format: "%.2f", percent)
            
            if percent >= 0 {
                self.percentPer.textColor = .green
                self.percentPer.text = "+" + formattedPercent + "%"
            } else {
                self.percentPer.textColor = .red
                self.percentPer.text = formattedPercent + "%"
            }
        } else {
            self.percentPer.text = percentPer
            self.percentPer.textColor = .black
        }
    }
}
