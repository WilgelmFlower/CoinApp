import UIKit
import SnapKit
import SDWebImage

final class ViewController: UIViewController {

    private var coinArray = [CoinModel]()
    private var filteredCoinArray = [CoinModel]()
    private var refreshControl = UIRefreshControl()
    private var currentPage = 0
    private var isLoadingData = false

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.rowHeight = 100
        table.dataSource = self
        table.delegate = self
        table.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)

        return table
    }()

    private let titleView = TitleView()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.isHidden = true
        searchBar.sizeToFit()

        return searchBar
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "moon")!)
        setup()
        loadFirstPage()
    }

    func loadFirstPage() {
        APIManager.shared.getCoinsData(page: 0) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let coinData):
                DispatchQueue.main.async {
                    self.coinArray = coinData
                    self.filteredCoinArray = coinData
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(let error):
                switch error {
                case NetworkError.invalidURL:
                    print("Invalid URL")
                case NetworkError.noData:
                    print("No data recieved")
                default:
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func loadNextPage() {
        guard !isLoadingData else { return }
        isLoadingData = true
        APIManager.shared.getCoinsData(page: currentPage + 10) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingData = false
            switch result {
            case .success(let coinData):
                DispatchQueue.main.async {
                    self.coinArray += coinData
                    self.filteredCoinArray += coinData
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(let error):
                switch error {
                case NetworkError.invalidURL:
                    print("Invalid URL")
                case NetworkError.noData:
                    print("No data recieved")
                default:
                    print(error.localizedDescription)
                }
            }
        }
    }

    func setup() {
        view.addSubview(tableView)
        view.addSubview(searchBar)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-100)
        }

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        titleView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        navigationItem.titleView = titleView
    }

    @objc func searchButtonTapped() {
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.isHidden = false
        navigationItem.titleView = searchBar
    }

    @objc func refreshData() {
        loadFirstPage()
    }
}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCoinArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCoinArray[section].data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.identifier, for: indexPath) as? CoinCell else {
            return UITableViewCell()
        }

        if indexPath.row < filteredCoinArray[indexPath.section].data.count {
            let coinModel = filteredCoinArray[indexPath.section].data[indexPath.item]
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.configure(fullName: coinModel.name, shortName: coinModel.symbol, totalSum: coinModel.priceUsd, percentPer: coinModel.changePercent24Hr)
            if let imageURL = URL(string: "https://cryptoicons.org/api/icon/\(coinModel.symbol.lowercased())/200") {
                cell.coinImage.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "rays"))
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        let selectedCoin = coinArray[indexPath.section].data[indexPath.row]
        detailsViewController.marketValue.text = selectedCoin.marketCapUsd.formattedNumber
        detailsViewController.supplyValue.text = selectedCoin.supply.formattedNumber
        detailsViewController.volumeValue.text = selectedCoin.volumeUsd24Hr.formattedNumber
        detailsViewController.titleLabel.text = selectedCoin.name

        if let percent = Double(selectedCoin.changePercent24Hr) {
            let formattedPercent = String(format: "%.2f", percent)

            if percent >= 0 {
                detailsViewController.percentLabel.textColor = .green
                detailsViewController.percentLabel.text = "+" + formattedPercent + "%"
            } else {
                detailsViewController.percentLabel.textColor = .red
                detailsViewController.percentLabel.text = formattedPercent + "%"
            }
        } else {
            detailsViewController.percentLabel.text = selectedCoin.changePercent24Hr
            detailsViewController.percentLabel.textColor = .black
        }

        let backButtonTitle = UIBarButtonItem()
        backButtonTitle.title = "\(selectedCoin.name)"
        backButtonTitle.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24),
                                                NSAttributedString.Key.foregroundColor: UIColor.white],
                                               for: .normal)
        let popToRootButton = UIBarButtonItem()
        popToRootButton.customView = backButton
        detailsViewController.navigationItem.leftBarButtonItems = [popToRootButton, backButtonTitle]
        backButton.addTarget(detailsViewController, action: #selector(detailsViewController.backButtonTapped), for: .touchUpInside)

        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}


extension ViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        if deltaOffset <= 0 {
            loadNextPage()
            currentPage += 10
        }

        if currentOffset > 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = titleView
        searchBar.showsCancelButton = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCoinArray.removeAll()
        if searchText == "" {
            filteredCoinArray = coinArray
        } else {
            for item in coinArray {
                let filteredData = item.data.filter { coin in
                    let lowercasedSearchText = searchText.lowercased()
                    let lowercasedName = coin.name.lowercased()
                    let lowercasedSymbol = coin.symbol.lowercased()
                    return lowercasedName.contains(lowercasedSearchText) || lowercasedSymbol.contains(lowercasedSearchText)
                }
                filteredCoinArray.append(CoinModel(data: filteredData))
            }
        }
        tableView.reloadData()
    }
}
