//
//  ColorPathSelector+Hex.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    public struct HexSeletor {
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            toXYZ.pathId:                 toXYZ,
            
            fromsRGB.pathId:              fromsRGB,
            fromAppleRGB.pathId:          fromAppleRGB,
            fromAdobeRGB.pathId:          fromAdobeRGB,
            fromBT2020RGB.pathId:         fromBT2020RGB,
            fromBT709RGB.pathId:          fromBT709RGB,
            fromDCIP3RGB.pathId:          fromDCIP3RGB,
            fromDCIP3PRGB.pathId:         fromDCIP3PRGB,
            fromDisplayP3RGB.pathId:      fromDisplayP3RGB,
            fromCIERGB.pathId:            fromCIERGB,
            fromAdobeWideGamutRGB.pathId: fromAdobeWideGamutRGB
        ]
        
        public static let toXYZ: PathConverter = .init( .Hex ==> .XYZ ) {
            let color = $0.base as! Hex
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.toXYZ(color: color, illuminant: illuminant, infos: infos)
            )
        }
        
        public static let tosRGB: PathConverter = .init( .Hex ==> .sRGB) {
            let color = $0.base as! Hex
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.tosRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
    
        public static let toAppleRGB: PathConverter = .init( .Hex ==> .AppleRGB) {
            let color = $0.base as! Hex
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.toAppleRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
    
        public static let toAdobeRGB: PathConverter = .init( .Hex ==> .AdobeRGB) {
            let color = $0.base as! Hex
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.toAdobeRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
    
        public static let toBT2020RGB: PathConverter = .init( .Hex ==> .BT2020RGB) {
            let color = $0.base as! Hex
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.toBT2020RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
    
        public static let toBT709RGB: PathConverter = .init( .Hex ==> .BT709RGB) {
            let color = $0.base as! Hex
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toBT709RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
    
        public static let toDCIP3RGB: PathConverter = .init( .Hex ==> .DCIP3RGB) {
            let color = $0.base as! Hex
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toDCIP3RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
    
        public static let toDCIP3PRGB: PathConverter = .init( .Hex ==> .DCIP3PRGB) {
            let color = $0.base as! Hex
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toDCIP3PRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
    
        public static let toDisplayP3RGB: PathConverter = .init( .Hex ==> .DisplayP3RGB) {
            let color = $0.base as! Hex
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toDisplayP3RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
    
        public static let toCIERGB: PathConverter = .init( .Hex ==> .CIERGB) {
            let color = $0.base as! Hex
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toCIERGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
    
        public static let toAdobeWideGamutRGB: PathConverter = .init( .Hex ==> .AdobeWideGamutRGB) {
            let color = $0.base as! Hex
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toAdobeWideGamutRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
    
        public static let fromsRGB: PathConverter = .init( .sRGB ==> .Hex) {
            let color = $0.base as! sRGB
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.fromsRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let fromAppleRGB: PathConverter = .init( .AppleRGB ==> .Hex) {
            let color = $0.base as! AppleRGB
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.fromAppleRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let fromAdobeRGB: PathConverter = .init( .AdobeRGB ==> .Hex) {
            let color = $0.base as! AdobeRGB
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.fromAdobeRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let fromBT2020RGB: PathConverter = .init( .BT2020RGB ==> .Hex) {
            let color = $0.base as! BT2020RGB
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.fromBT2020RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let fromBT709RGB: PathConverter = .init( .BT709RGB ==> .Hex) {
            let color = $0.base as! BT709RGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.fromBT709RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let fromDCIP3RGB: PathConverter = .init( .DCIP3RGB ==> .Hex) {
            let color = $0.base as! DCIP3RGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.fromDCIP3RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let fromDCIP3PRGB: PathConverter = .init( .DCIP3PRGB ==> .Hex) {
            let color = $0.base as! DCIP3PRGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.fromDCIP3PRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let fromDisplayP3RGB: PathConverter = .init( .DisplayP3RGB ==> .Hex) {
            let color = $0.base as! DisplayP3RGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.fromDisplayP3RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let fromCIERGB: PathConverter = .init( .CIERGB ==> .Hex) {
            let color = $0.base as! CIERGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.fromCIERGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let fromAdobeWideGamutRGB: PathConverter = .init( .AdobeWideGamutRGB ==> .Hex) {
            let color = $0.base as! AdobeWideGamutRGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.fromAdobeWideGamutRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
    
    }
}

extension ColorPathSelector.HexSeletor {
    
    public static func toXYZ(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> XYZ {
        
        let downColor = color.downable()
        let colorTuple: RGBColorable.FloatTuple = (
            downColor.red, downColor.green, downColor.blue, downColor.illuminant
        )
        
        func rgb<T: RGBColorable>(_ v: T.Type) -> XYZ {
            return ColorPathSelector.RGBSelector.RGBToXYZ(
                color: v.init(rgb: colorTuple), illuminant: illuminant, infos: infos
            )
        }
        
        switch color.rgbColorSpace {
        case .unknown:           return rgb(sRGB.self)
        case .sRGB:              return rgb(sRGB.self)
        case .AppleRGB:          return rgb(AppleRGB.self)
        case .AdobeRGB:          return rgb(AdobeRGB.self)
        case .BT2020RGB:         return rgb(BT2020RGB.self)
        case .BT709RGB:          return rgb(BT709RGB.self)
        case .DCIP3RGB:          return rgb(DCIP3RGB.self)
        case .DCIP3PRGB:         return rgb(DCIP3PRGB.self)
        case .DisplayP3RGB:      return rgb(DisplayP3RGB.self)
        case .CIERGB:            return rgb(CIERGB.self)
        case .AdobeWideGamutRGB: return rgb(AdobeWideGamutRGB.self)
        }
        
    }
    
    /// - Tag: Hex -> xRGB
    public static func HexToRGB<R: RGBColorable>(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> R {

        ColorPathSelector.XYZSelector.toRGB(
            color: toXYZ(
                color: color, illuminant: illuminant, infos: infos
            ),
            illuminant: illuminant,
            infos: infos
        )

    }

    public static func tosRGB(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> sRGB {
        HexToRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toAppleRGB(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> AppleRGB {
        HexToRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toAdobeRGB(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> AdobeRGB {
        HexToRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toBT2020RGB(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> BT2020RGB {
        HexToRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toBT709RGB(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> BT709RGB {
        HexToRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toDCIP3RGB(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> DCIP3RGB {
        HexToRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toDCIP3PRGB(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> DCIP3PRGB {
        HexToRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toDisplayP3RGB(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> DisplayP3RGB {
        HexToRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toCIERGB(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> CIERGB {
        HexToRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toAdobeWideGamutRGB(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> AdobeWideGamutRGB {
        HexToRGB(color: color, illuminant: illuminant, infos: infos)
    }

    /// - Tag: xRGB -> Hex
    public static func RGBToHex<T: RGBColorable>(color: T, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {

        .init(mapping: color)
    }

    public static func fromsRGB(color: sRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {
        RGBToHex(color: color, illuminant: illuminant, infos: infos)
    }

    public static func fromAppleRGB(color: AppleRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {
        RGBToHex(color: color, illuminant: illuminant, infos: infos)
    }

    public static func fromAdobeRGB(color: AdobeRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {
        RGBToHex(color: color, illuminant: illuminant, infos: infos)
    }

    public static func fromBT2020RGB(color: BT2020RGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {
        RGBToHex(color: color, illuminant: illuminant, infos: infos)
    }

    public static func fromBT709RGB(color: BT709RGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {
        RGBToHex(color: color, illuminant: illuminant, infos: infos)
    }

    public static func fromDCIP3RGB(color: DCIP3RGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {
        RGBToHex(color: color, illuminant: illuminant, infos: infos)
    }

    public static func fromDCIP3PRGB(color: DCIP3PRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {
        RGBToHex(color: color, illuminant: illuminant, infos: infos)
    }

    public static func fromDisplayP3RGB(color: DisplayP3RGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {
        RGBToHex(color: color, illuminant: illuminant, infos: infos)
    }

    public static func fromCIERGB(color: CIERGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {
        RGBToHex(color: color, illuminant: illuminant, infos: infos)
    }

    public static func fromAdobeWideGamutRGB(color: AdobeWideGamutRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {
        RGBToHex(color: color, illuminant: illuminant, infos: infos)
    }
    
}
