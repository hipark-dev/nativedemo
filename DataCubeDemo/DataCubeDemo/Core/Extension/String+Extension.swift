//
//  String+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension String {
    var removeComma: String {
        self.replacingOccurrences(of: ",", with: "", options: .literal, range: nil)
    }
    var decimal: String {
        convertCurrency(style: .decimal)
    }
    
    var decimalCurrency: String {
        self.isEmpty ? "" : UIConstant.monetary + decimal
    }
    
    var decimalCurrencyWithMinus: String {
        self.isEmpty ? "" : UIConstant.minus + UIConstant.monetary + decimal
    }
    
    var decimalCurrencyWithSpace: String {
        self.isEmpty ? "" : UIConstant.monetary + UIConstant.space + decimal
    }
    
    var decimalCurrencyFixing: String {
        self.isEmpty ? "$" : UIConstant.monetary + decimal
    }
    
    func convertCurrency(style: NumberFormatter.Style) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        
        guard let doubleValue = Double(self), let converted = formatter.string(from: NSNumber(value: doubleValue)) else {
            return self
        }
        
        return converted
    }
    var digits: String {
        components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    var decimalFractionDigits: String {
        let characterSet = CharacterSet(charactersIn: "01234567890.").inverted
        return components(separatedBy: characterSet)
            .joined()
    }
    static func remove(sourceString: String, removeString: String) -> String {
        sourceString.replacingOccurrences(of: removeString, with: "")
    }
    var convertInt64: Int64 {
        guard let convert = Int64(self.removeComma.replacingOccurrences(of: "$", with: "", options: .literal, range: nil)) else {
            return 0
        }
        return convert
    }
    var convertInt: Int {
        guard let convert = Int(self.removeComma.replacingOccurrences(of: "$", with: "", options: .literal, range: nil)) else {
            return 0
        }
        return convert
    }
    
    func attributedCurrency(by font: StyleNumberFont) -> NSAttributedString {
        attributedCurrency(font.applyAlphabet, font.applyDigit)
    }
    
    func attributedCurrency(_ basicFont: UIFont, _ currencyFont: UIFont, _ baseoffset: CGFloat? = nil) -> NSMutableAttributedString {
        let currencyRange = NSRange(location: self.count - 1, length: 1)
        let attributedString = NSMutableAttributedString(string: self,
                                                         attributes: [.font: basicFont])
        if !digits.count.isZero {
            attributedString.setAttributes([.font: currencyFont], range: currencyRange)
        }
        
        if let baseoffset = baseoffset {
            attributedString.addAttribute(.baselineOffset, value: baseoffset, range: currencyRange)
        }
        
        return attributedString
    }
    
    func attributedSubString(_ subString: String, _ subStringFont: UIFont, sourceFont: UIFont) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self,
                                                         attributes: [.font: sourceFont])
        let subRange = attributedString.mutableString.range(of: subString, options: .caseInsensitive)
        attributedString.setAttributes([.font: subStringFont], range: subRange)
        return attributedString
    }
    
    static func removeLastIndex(source: String) -> String {
        var input = source
        if input.count > 0 {
            input.removeLast()
        }
        return input
    }
    var exist: Bool {
        self.count > 0
    }
    var notExist: Bool {
        self.count <= 0
    }
    func date(_ format: DateStringFormat) -> Date {
        DateFormatUtil.date(self, format)
    }
    func cutString(_ len: Int) -> String {
        if self.count > len {
            let startIndex = self.index(self.startIndex, offsetBy: 0)
            let endIndex = self.index(self.startIndex, offsetBy: len)
            let range: Range<Index> = startIndex..<endIndex
            return String(self[range])
        }
        return self
    }
}

// MARK: base64 Encode
extension String {
    func decodeBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func encodeBase64(options: Data.Base64EncodingOptions = []) -> String {
        Data(self.utf8).base64EncodedString(options: options)
    }
}
// MARK: URL Encode
extension String {
    var encodedUrlWithUrlFragmentAllowed: URL? {
        URL(string: addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed).unwrap())
    }
    var urlEncode: String? {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    var qrUrlEncode: String? {
        addingPercentEncoding(withAllowedCharacters: .urlAllowedCharacters)
    }
}

extension String {
    static func attributedStringCat(_ destination: String, _ destinationFont: UIFont, _ destinationFontColor: UIColor?, _ soure: String, _ sourceFont: UIFont, _ sourceFontColor: UIColor?) -> NSMutableAttributedString {
        
        let destAttributes: [NSAttributedString.Key: Any]
        if let destinationFontColor = destinationFontColor {
            destAttributes = [.font: destinationFont, .foregroundColor: destinationFontColor]
        } else {
            destAttributes = [.font: destinationFont]
        }
        
        let srcAttributes: [NSAttributedString.Key: Any]
        if let sourceFontColor = sourceFontColor {
            srcAttributes = [.font: sourceFont, .foregroundColor: sourceFontColor]
        } else {
            srcAttributes = [.font: sourceFont]
        }
        
        let dest = NSMutableAttributedString(string: destination, attributes: destAttributes)
        let src = NSMutableAttributedString(string: soure, attributes: srcAttributes)
        dest.append(src)
        return dest
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func addPrefix(_ prefix: String) -> String {
        prefix + self
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        prefix(1).uppercased() + dropFirst()
    } 
}

extension String {
    func highlightWordsIn(highlightedWords: String, attributes: [[NSAttributedString.Key: Any]]) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: highlightedWords)
        let result = NSMutableAttributedString(string: self)
        
        for attribute in attributes {
            result.addAttributes(attribute, range: range)
        }
        
        return result
    }
}

extension String {
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            Logger.error("error: \(error)")
            return nil
        }
    }
}

// MARK: Util
extension String {
    mutating func insert(string: String, offsetIndex: Int) {
        guard count > offsetIndex else {
            return
        }
        insert(contentsOf: string, at: string.index(string.startIndex, offsetBy: offsetIndex) )
    }
    func trim() -> String {
        trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    var isResultY: Bool {
        uppercased() == "Y"
    }
    var isBlank: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isNotBlank: Bool {
        !self.isBlank
    }
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    var isNumeric: Bool {
        let numberChars = NSCharacterSet.decimalDigits.inverted
        return !self.isEmpty && self.rangeOfCharacter(from: numberChars) == nil
    }
    
    // LEFT
    // Returns the specified number of chars from the left of the string
    // let str = "Hello"
    // print(str.left(3))         // Hel
    func left(_ to: Int) -> String {
        if self.count <= to {
            return self
        }
        
        return self[..<to]
    }
    
    // RIGHT
    // Returns the specified number of chars from the right of the string
    // let str = "Hello"
    // print(str.left(3))         // llo
    func right(_ from: Int) -> String {
        self[(self.count - from)...]
    }
    
    var prettyString: String {
        guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false), let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
            return self
        }
        
        return json.prettyString 
    }
    
    var json: [String: AnyObject]? {
        guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false), let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
            return nil
        }
        
        return json
    }
    
    var kilometer: String {
        self + "km"
    }
    
    var meter: String {
        self + "m"
    }
}

extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        NSRange(range, in: self)
    }
}

extension String: HasLet {
}

extension String {
 
    subscript(value: CountableClosedRange<Int>) -> String {
        String(self[index(at: value.lowerBound)...index(at: value.upperBound)])
    }
    
    subscript(value: CountableRange<Int>) -> String {
        String(self[index(at: value.lowerBound)..<index(at: value.upperBound)])
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> String {
        String(self[..<index(at: value.upperBound)])
    }
    
    subscript(value: PartialRangeThrough<Int>) -> String {
        String(self[...index(at: value.upperBound)])
    }
    
    subscript(value: PartialRangeFrom<Int>) -> String {
        String(self[index(at: value.lowerBound)...])
    }
    
    func index(at offset: Int) -> String.Index {
        index(startIndex, offsetBy: offset)
    }
    
    subscript(value range: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        let range: Range<Index> = start..<end
        return String(self[range])
    }
}

extension String {
    func maskedString(mask: String = UIConstant.bigCircle,
                      defaultFont: UIFont,
                      weight: UIFont.Weight,
                      range: NSRange,
                      kern: CGFloat = 2,
                      kernOnMask: CGFloat? = nil,
                      maskFont: UIFont? = nil) -> NSMutableAttributedString {
        guard let rangeExpression = Range(range, in: self) else {
            return NSMutableAttributedString(string: "__unknown__")
        }
        let repatingMask = Array(repeating: mask, count: range.length).joined()
        let maskedString = self.replacingCharacters(in: rangeExpression, with: repatingMask)
        let attributedString = NSMutableAttributedString(string: maskedString)
        
        let fullRange = NSRange(location: 0, length: self.count)
        attributedString.setAttributes([.font: defaultFont], range: fullRange)
        let maskFont: UIFont = maskFont ?? .systemFont(ofSize: defaultFont.pointSize, weight: weight)
        attributedString.addAttributes([.font: maskFont], range: range)
        attributedString.addAttributes([.kern: kern], range: fullRange)
        attributedString.addAttributes([.kern: kernOnMask ?? kern], range: range)
        if defaultFont.pointSize != maskFont.pointSize {
            attributedString.addAttribute(.baselineOffset, value: (defaultFont.pointSize - maskFont.pointSize) / 2, range: range)
        }
        return attributedString
    }
    
    func allMasked(
        _ mask: String = UIConstant.bigCircle,
        font: UIFont = .systemFont(ofSize: 13),
        kern: CGFloat = 2,
        baseLine: CGFloat = 0) -> NSMutableAttributedString? {
        
        let range = NSRange(location: 0, length: self.count)
        let maskedString = Array(repeating: mask, count: range.length).joined()
        let attributedString = NSMutableAttributedString(string: maskedString)
        
        attributedString.addAttributes([.font: font], range: range)
        attributedString.addAttributes([.kern: kern], range: range)
        attributedString.addAttribute(.baselineOffset, value: baseLine, range: range)
        
        return attributedString
    }
    
    func maskedCardNumberString(defaultFont: UIFont, maskFont: UIFont, kern: CGFloat) -> NSAttributedString? {
        guard count >= 16 else { return nil }
        
        let attributedString = maskedString(defaultFont: defaultFont,
                                            weight: .regular,
                                            range: NSRange(location: 6, length: 6),
                                            kern: kern,
                                            maskFont: maskFont)
        
        attributedString.insert(UIConstant.space.attributedString(), at: 4)
        attributedString.insert(UIConstant.space.attributedString(), at: 9)
        attributedString.insert(UIConstant.space.attributedString(), at: 14)
        
        return attributedString
    }
}

extension String {
    func `repeat`(count: Int) -> String {
        Array(repeatElement(self, count: count)).joined()
    }
}

extension NSMutableAttributedString {
    
    func setForceColor(searchStr: String, color: UIColor) -> NSMutableAttributedString {
        
        let attrStr = self
        let entireLength = self.length
        var range = NSRange(location: 0, length: entireLength)
        var rangeArr = [NSRange]()
        
        while range.location != NSNotFound {
            
            range = (attrStr.string as NSString).range(of: searchStr, options: .caseInsensitive, range: range)
            rangeArr.append(range)
            if range.location != NSNotFound {
                range = NSRange(location: range.location + range.length, length: entireLength - (range.location + range.length))
            }
        }
        
        rangeArr.forEach { range in
            attrStr.addAttribute(.foregroundColor, value: color, range: range)
        }
        
        return attrStr
    }
    
    func setStringUnderLine(_ text: String) -> NSMutableAttributedString {
            
        let attributedString = NSMutableAttributedString(string: self.string)
        let range = (self.string as NSString).range(of: text)

        attributedString.addAttribute(.font, value: StyleFont.body4(weight: .regular).apply, range: NSRange(location: 0, length: self.length))
        attributedString.addAttribute(.foregroundColor, value: StyleColor.gray_74767D.apply, range: NSRange(location: 0, length: self.length))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)

        return attributedString
        
    }
    
    func setStringStrikethroughLine(_ text: String, font: StyleFont) -> NSMutableAttributedString {
            
        let attributedString = NSMutableAttributedString(string: self.string)
        let range = (self.string as NSString).range(of: text)

        attributedString.addAttribute(.font, value: font.apply, range: NSRange(location: 0, length: self.length))
        attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        return attributedString
        
    }
}

extension String {
    /// ex) "(some string)"
    var parenthesis: String {
        "(" + self + ")"
    }
    
    /// ex) "( some string )"
    var parenthesisWithSpace: String {
       [ "(", self, ")" ].joined(separator: " ")
    }
    
    func removeBraket() -> String {
        var copy = self
        copy = copy.replacingOccurrences(of: UIConstant.leftParentheses, with: UIConstant.empty)
        copy = copy.replacingOccurrences(of: UIConstant.rightParentheses, with: UIConstant.empty)
        return copy
    }
}

extension String {
    enum LetterCases {
        case upperCased
        case lowerCased
        case titleCased
    }
    
    func titleCased() -> String {
        capitalizingFirstLetter()
    }
  
    var toColor: UIColor {
        
        let hexStr = self
        
        let hex = hexStr.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let alpha, red, green, blue: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        return UIColor.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
    
    func getLastDigit(_ len: Int) -> String {
        if self.count >= len { return UIConstant.ellipsisThree + String(self.suffix(len)) }
        return self
    }
}

extension String {
    var toDictionary: [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                Logger.error(error.localizedDescription)
            }
        }
        return nil
    }
}

extension String {
    //TODO: seperate file to String+regex
    var hasHanOrSFS: Bool {
        let sfsPrivateRange = "\\uD840\\uDC00-\\uD87F\\uDFFF\\uDB80\\uDC00-\\uDBBF\\uDFFD\\uDBC0\\uDC00-\\uDBFF\\uDFFD"
        let sfsBmpRange = "\\u3400-\\u4DBF\\uE000-\\uF8FF"
        let sfsEachOtherRange = "\\u02BC,\\u005E,\\u2203,\\u1E5F,\\u00E9,\\u0268,\\u0269"
        let han = "\\p{script=Han}"
        guard let regex: NSRegularExpression = try? .init(pattern: "^[\(sfsPrivateRange)\(sfsBmpRange)\(sfsEachOtherRange)\(han)]+$", options: []) else { return false }
        guard regex.matches(in: self, options: [], range: range(self.count)).count == 1 else { return false }
        return true
    }
    
    func nationalIdValidate(idx: Int ) -> Bool {
        let pattern: String = "^[A-Z]{1}[0-9]{\(String(idx)),9}$"
        guard let regex: NSRegularExpression = try? .init(pattern: pattern, options: []) else { return false }
        guard regex.matches(in: self, options: [], range: range(self.count)).count == 1 else { return false }
        return true
    }
    
    func editingNationalIdValidation(regex pattern: String = "^[A-Z]{1}[0-9]{0,9}$") -> Bool {
        guard let regex: NSRegularExpression = try? .init(pattern: pattern, options: []) else { return false }
        guard regex.matches(in: self, options: [], range: range(self.count)).count == 1 else { return false }
        return true
    }
    
    func hasLetterAndDigit(regex pattern: String = "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]+$") -> Bool {
        guard let regex: NSRegularExpression = try? .init(pattern: pattern, options: []) else { return false }
        guard regex.matches(in: self, options: [], range: range(self.count)).count == 1 else { return false }
        return true
    }
    
    func hasAddressInputRule(regex pattern: String = "^(?=.*[a-zA-Z])(?=.*[\\uE000-\\uF8FF])(?=.*[\\p{script=Han}])(?=.*[\\U+002C])+$") -> Bool {
        guard let regex: NSRegularExpression = try? .init(pattern: pattern, options: []) else { return false }
        guard regex.matches(in: self, options: [], range: range(self.count)).count == 1 else { return false }
        return true
    }
    
    func hasSameChar(regex pattern: String = "(\\w)\\1\\1") -> Bool {
        guard let regex: NSRegularExpression = try? .init(pattern: pattern, options: []) else { return false }
        guard regex.matches(in: self, options: [], range: range(self.count)).count > 0 else { return false }
        return true
    }
    
    func hasOnlyLetter(regex pattern: String = "^[a-zA-Z]+$") -> Bool {
        guard let regex: NSRegularExpression = try? .init(pattern: pattern, options: []) else { return false }
        guard regex.matches(in: self, options: [], range: range(self.count)).count == 1 else { return false }
        return true
    }
    
    func hasOnlyDigit(regex pattern: String = "^[0-9]+$") -> Bool {
        guard let regex: NSRegularExpression = try? .init(pattern: pattern, options: []) else { return false }
        guard regex.matches(in: self, options: [], range: range(self.count)).count == 1 else { return false }
        return true
    }
    
    // English, Taiwanese, Blanks, Symbols is only comma
    func hasAliasInputRule(regex pattern: String = "^[a-zA-Z,, \\u02CA\\u02C9\\u02C7\\u02CB\\u02D9\\p{script=Han}\\u4E00-\\u9FFF\\u3105-\\u3129]+$") -> Bool {
        guard let regex: NSRegularExpression = try? .init(pattern: pattern, options: []) else { return false }
        guard regex.matches(in: self, options: [], range: range(self.count)).count == 1 else { return false }
        return true
    }
    
    // English, Taiwanese, Blanks, Number, except special symbol
       func hasRestrictSymbolInputRule(regex pattern: String = "^[a-zA-Z0-9,,_-·• \\u02CA\\u02C9\\u02C7\\u02CB\\u02D9\\p{script=Han}\\u4E00-\\u9FFF\\u3105-\\u3129]+$") -> Bool {
           guard let regex: NSRegularExpression = try? .init(pattern: pattern, options: []) else { return false }
           guard regex.matches(in: self, options: [], range: range(self.count)).count == 1 else { return false }
           return true
    }
    
    // English, Blanks, '-'
    func hasEnglishNameRule(regex pattern: String = "^[a-zA-Z -]+$") -> Bool {
        guard let regex: NSRegularExpression = try? .init(pattern: pattern, options: []) else { return false }
        guard regex.matches(in: self, options: [], range: range(self.count)).count == 1 else { return false }
        return true
    }
    
    // Email Address Validation
    func isValidEmailAddress(regex pattern: String = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$") -> Bool {
        guard let regex: NSRegularExpression = try? .init(pattern: pattern, options: []) else { return false }
        guard regex.matches(in: self, options: [], range: range(self.count)).count == 1 else { return false }
        return true
    }
    
    func hasContinuous(maxPatternCount: Int) -> Bool {
        var continuousCount: Int = 1
        var reverseContinuousCount: Int = 1
        for index in 0..<self.count {
            if index == self.count - 1 {
                break
            }
            let currentAsciiValue: Int = Character(self[index..<index + 1]).asciiValue
            let nextAsciiValue: Int = Character(self[(index + 1)..<(index + 2)]).asciiValue
            if currentAsciiValue + 1 == nextAsciiValue {
                continuousCount += 1
                reverseContinuousCount = 1
            } else if currentAsciiValue - 1 == nextAsciiValue {
                continuousCount = 1
                reverseContinuousCount += 1
            } else {
                continuousCount = 1
                reverseContinuousCount = 1
            }
            
            if continuousCount >= maxPatternCount || reverseContinuousCount >= maxPatternCount {
                return true
            }
        }
        return false
    }
    
    func range(_  count: Int) -> NSRange {
        .init(location: 0, length: count)
    }
}

extension String {
    var formattedAccountNumber: String {
        if self.count != 12 {
            return self
        }
        
        return "\(self[0...2])-\(self[3...6])-\(self[7...11])"
    }
}

extension String {
    func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
}

extension String {
    enum TruncationPosition {
        case head
        case middle
        case tail
    }
    
    func truncated(limit: Int, position: TruncationPosition = .tail, leader: String = "") -> String {
        guard self.count > limit else { return self }
        
        switch position {
        case .head:
            return leader + self.suffix(limit)
        case .middle:
            let headCharactersCount = Int(ceil(Float(limit - leader.count) / 2.0))
            let tailCharactersCount = Int(floor(Float(limit - leader.count) / 2.0))
            return "\(self.prefix(headCharactersCount))\(leader)\(self.suffix(tailCharactersCount))"
        case .tail:
            return self.prefix(limit) + leader
        }
    }
    
    static var empty: Self { UIConstant.empty }
    static var unknown: Self { UIConstant.unknown }
    static var percent: Self { UIConstant.percent }
    static var space: Self { UIConstant.space }
}

extension String {
    /// ## if needed strike line  syle set to strikethroughStyle
    func applyUnderline(_ font: UIFont = StyleFont.body3(weight: .regular).apply,
                        color: UIColor = StyleColor.gray_74767D.apply) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes( [
            .font: font,
            .foregroundColor: color,
            .underlineStyle: NSUnderlineStyle.single.rawValue
            
        ], range: (self as NSString).range(of: self))
        return attributedString
    }
    
    func applystrikethrough(_ font: UIFont = StyleFont.body3(weight: .regular).apply,
                            color: UIColor = StyleColor.gray_74767D.apply) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes( [
            .font: font,
            .foregroundColor: color,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
            
        ], range: (self as NSString).range(of: self))
        return attributedString
    }
    
    func attributedString(kern: CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes( [.kern: kern], range: (self as NSString).range(of: self))
        return attributedString
    }
}

extension CharacterSet {
    static var urlAllowedCharacters: CharacterSet {
        CharacterSet(charactersIn: "\"#%:/<>=?@\\^`{|}").inverted
    }
}
