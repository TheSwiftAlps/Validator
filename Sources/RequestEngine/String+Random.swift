import Foundation

extension String {
    ///  Generates a random string of a certain length.
    ///  Courtesy of
    ///  https://stackoverflow.com/a/33860834/133764
    ///
    /// - Parameter length: The length of the resulting string.
    /// - Returns: A random string.
    public static func randomString(_ length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = allowedChars.count
        var randomString = ""

        for _ in 0..<length {
            let randomNum = allowedCharsCount.randomFromZeroToMe()
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }

        return randomString
    }

    /// Generates a random e-mail ending in ".com"
    ///
    /// - Returns: A string with a random e-mail.
    public static func randomEmail() -> String {
        let randomEmail = "\(String.randomString(5))@\(String.randomString(10)).com"
        return randomEmail.lowercased()
    }
}
