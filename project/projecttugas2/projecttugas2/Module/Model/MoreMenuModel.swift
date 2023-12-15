import Foundation

struct MoreMenuModel {
    let title: String
    let logo: String
    
    static var dataMoreMenu = [
        MoreMenuModel(title: .localized("editprofile"), logo: "pencil"),
        //MoreMenuModel(title: "settings".localized, logo: "gearshape.fill"),
        //MoreMenuModel(title: "about".localized, logo: "quote.opening"),
        MoreMenuModel(title: .localized("logout"), logo: "rectangle.portrait.and.arrow.right")
    ]
    
    static var dataSettings = [
        MoreMenuModel(title: "Language", logo: "character"),
        MoreMenuModel(title: "App Mode", logo: "sun.max")
    ]
}

struct LanguageModel {
    let title: String
    
    static var dataLanguage =  [
        LanguageModel(title: "Bahasa Indonesia"),
        LanguageModel(title: "English"),
        LanguageModel(title: "Javanese"),
        LanguageModel(title: "Chinese")
    ]
}
