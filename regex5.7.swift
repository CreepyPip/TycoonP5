import Foundation

struct regex {
    private let internalRegex: NSRegularExpression?
    
    init(_ pattern: String, ignoreCase: Bool = true) {
        var options: NSRegularExpression.Options = []
        if ignoreCase {
            options.insert(.caseInsensitive)
        }
        
        self.internalRegex = try? NSRegularExpression(pattern: pattern, options: options)
    }
    
    func matches(_ text: String) -> Bool {
        guard let regex = internalRegex else { return false }
        let range = NSRange(text.startIndex..., in: text)
        return regex.firstMatch(in: text, options: [], range: range) != nil
    }
}
