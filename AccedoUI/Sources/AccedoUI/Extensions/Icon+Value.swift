import Foundation

extension Icon {
    var assetName: String {
        let prefix = "icon_"

        let postfix: String
        switch self {
            case .appTitleIcon:
                postfix = "ApplicationTitle"
        }

        return prefix + postfix
    }
}
