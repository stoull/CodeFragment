//
//  MGColors.swift
//  MyGro
//
//  Created by Hut on 2021/12/10.
//  Copyright © 2021 Growatt New Energy Technology CO.,LTD. All rights reserved.
//

import UIKit

// MARK: - 颜色相关
var kThemeColor: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#353645")
            } else {
                return kHexColor("#FFFFFF")
            }
        }
    } else {
        return kHexColor("#FFFFFF")
    }
}()

var kThemeColor_white: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#2E2E39")
            } else {
                return kHexColor("#FFFFFF")
            }
        }
    } else {
        return kHexColor("#FFFFFF")
    }
}()

var kThemeColor_black: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#353645")
            } else {
                return kHexColor("#2F3034")
            }
        }
    } else {
        return kHexColor("#000000")
    }
}()

var kThemeColor_error: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#FF4729")
            } else {
                return kHexColor("#FF4729")
            }
        }
    } else {
        return kHexColor("#FF4729")
    }
}()

var kThemeViewBackgroundColor_white: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#2E2E39")
            } else {
                return kHexColor("#FFFFFF")
            }
        }
    } else {
        return kHexColor("#FFFFFF")
    }
}()

var kThemeViewBackgroundColor_indicator: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#C8C8C8")
            } else {
                return kHexColor("#C8C8C8")
            }
        }
    } else {
        return kHexColor("#C8C8C8")
    }
}()

var kThemeViewBackgroundColor_inApp: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#2E2E39")
            } else {
                return kHexColor("#F0F3FA")
            }
        }
    } else {
        return kHexColor("#F0F3FA")
    }
}()

/// 便携电源页中的背景色
var kThemeViewBackgroundColor_top: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#2E2E39")
            } else {
                return kHexColor("#F0F3FA")
            }
        }
    } else {
        return kHexColor("#2E2E39")
    }
}()

/// 便携电源页中的背景色中内容的背景色
var kThemeViewBackgroundColor_top_content: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#ECEFF6")
            } else {
                return kHexColor("#FFFFFF")
            }
        }
    } else {
        return kHexColor("#ECEFF6")
    }
}()

var kThemeIconColor: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#FFFFFF")
            } else {
                return kHexColor("#535353")
            }
        }
    } else {
        return kHexColor("#535353")
    }
}()

var kThemeGradientColor_startColor: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#454344")
            } else {
                return kHexColor("#69B836")
            }
        }
    } else {
        return kHexColor("#69B836")
    }
}()

var kThemeGradientColor_endColor: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#454344")
            } else {
                return kHexColor("#04CBD9")
            }
        }
    } else {
        return kHexColor("#04CBD9")
    }
}()

var kThemeButtonBackgroundColor_light: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#F2F2F2")
            } else {
                return kHexColor("#F2F2F2")
            }
        }
    } else {
        return kHexColor("#F2F2F2")
    }
}()

var kThemeButtonBackgroundColor_heavy: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#A4A4A8")
            } else {
                return kHexColor("#A4A4A8")
            }
        }
    } else {
        return kHexColor("#A4A4A8")
    }
}()

var kThemeTextFieldBackgroundColor: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#373744")
            } else {
                return kHexColor("#F8F8F8")
            }
        }
    } else {
        return kHexColor("#F8F8F8")
    }
}()

/// Current apperace color is green color
var kThemeTextColor_color: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#6FB92C")
            } else {
                return kHexColor("#6FB92C")
            }
        }
    } else {
        return kHexColor("#6FB92C")
    }
}()

var kThemeTextColor_top: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#FFFFFF")
            } else {
                return kHexColor("#333333")
            }
        }
    } else {
        return kHexColor("#333333")
    }
}()

var kThemeTextColor_middle: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#666666")
            } else {
                return kHexColor("#666666")
            }
        }
    } else {
        return kHexColor("#666666")
    }
}()

var kThemeTextColor_bottom: UIColor = {
    if #available(iOS 13.0, *) {
        return UIColor { traitType in
            if traitType.userInterfaceStyle == .dark {
                return kHexColor("#888888")
            } else {
                return kHexColor("#888888")
            }
        }
    } else {
        return kHexColor("#888888")
    }
}()

func kRGBAColor(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat) -> UIColor {
    return UIColor.init(red: r, green: g, blue: b, alpha: a)
}
func kRGBColor(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat) -> UIColor {
    return UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
}
func kHexColorA(_ HexString: String,_ a: CGFloat) ->UIColor {
    return UIColor.colorWith(hexString: HexString, alpha: a)
}

func kHexColor(_ HexString: String) ->UIColor {
    return UIColor.colorWith(hexString: HexString)
}

// MARK: - 颜色相关
extension UIColor {
    // MARK: - Convert hex string to a UIColor instance
    class func colorWith(hexString:String, alpha: CGFloat = 1.0) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
