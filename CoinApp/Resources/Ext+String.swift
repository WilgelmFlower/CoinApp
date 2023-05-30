import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}

extension String {
    var formattedNumber: String {
        guard let number = Double(self) else {
            return self
        }

        let absNumber = abs(number)
        let suffixes = ["", "K", "M", "B"]

        var suffixIndex = 0
        var formattedNumber = absNumber

        while formattedNumber >= 1000 && suffixIndex < suffixes.count - 1 {
            formattedNumber /= 1000
            suffixIndex += 1
        }

        let roundedNumber = String(format: "%.2f", formattedNumber)
        let suffix = suffixes[suffixIndex]

        return "\(roundedNumber)\(suffix)"
    }
}
