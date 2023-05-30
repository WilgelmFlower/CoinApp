import Foundation

struct CoinModel: Codable {
    let data: [Coin]
}

struct Coin: Codable {
    let symbol: String
    let name: String
    let priceUsd: String
    let changePercent24Hr: String
    let marketCapUsd: String
    let supply: String
    let volumeUsd24Hr: String
}
