import Foundation

struct MoreMenuModel {
    let title: String
    let logo: String
    
    static var dataMoreMenu = [
        MoreMenuModel(title: .localized("editprofile"), logo: "pencil"),
        MoreMenuModel(title: .localized("logout"), logo: "rectangle.portrait.and.arrow.right")
    ]
    
    static var dataSettings = [
        MoreMenuModel(title: "Language", logo: "character"),
        MoreMenuModel(title: "App Mode", logo: "sun.max")
    ]
}

struct LanguageModel {
    let title: String
    let languageCode: String
    
    static var dataLanguage =  [
        LanguageModel(title: "Bahasa Indonesia", languageCode: "id"),
        LanguageModel(title: "English", languageCode: "en"),
        LanguageModel(title: "Javanese", languageCode: "jv"),
        LanguageModel(title: "Chinese", languageCode: "zh")
    ]
}
