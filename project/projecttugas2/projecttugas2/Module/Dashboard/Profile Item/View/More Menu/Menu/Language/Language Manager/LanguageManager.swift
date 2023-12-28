import Foundation


class LanguageManager {
    static let shared = LanguageManager()
    
    var currentLanguage: String {
        return BaseConstant.userDefaults.string(forKey: "AppLanguage") ?? "en"
    }
    
    func setLanguage(_ languageCode: String) {
        BaseConstant.userDefaults.set(languageCode, forKey: "AppLanguage")
        BaseConstant.userDefaults.synchronize()
    }
    
}
