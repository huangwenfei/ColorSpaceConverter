//
//  ColorPathSelector+RGB.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    public struct RGBSelector {
        
        public typealias Parent = ColorPathSelector
        public typealias Element = Parent.Element
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            sRGBToXYZ.pathId:              sRGBToXYZ,
            AppleRGBToXYZ.pathId:          AppleRGBToXYZ,
            AdobeRGBToXYZ.pathId:          AdobeRGBToXYZ,
            BT2020RGBToXYZ.pathId:         BT2020RGBToXYZ,
            BT709RGBToXYZ.pathId:          BT709RGBToXYZ,
            DCIP3RGBToXYZ.pathId:          DCIP3RGBToXYZ,
            DCIP3PRGBToXYZ.pathId:         DCIP3PRGBToXYZ,
            DisplayP3RGBToXYZ.pathId:      DisplayP3RGBToXYZ,
            CIERGBToXYZ.pathId:            CIERGBToXYZ,
            AdobeWideGamutRGBToXYZ.pathId: AdobeWideGamutRGBToXYZ,

            sRGBToHSV.pathId:              sRGBToHSV,
            AppleRGBToHSV.pathId:          AppleRGBToHSV,
            AdobeRGBToHSV.pathId:          AdobeRGBToHSV,
            BT2020RGBToHSV.pathId:         BT2020RGBToHSV,
            BT709RGBToHSV.pathId:          BT709RGBToHSV,
            DCIP3RGBToHSV.pathId:          DCIP3RGBToHSV,
            DCIP3PRGBToHSV.pathId:         DCIP3PRGBToHSV,
            DisplayP3RGBToHSV.pathId:      DisplayP3RGBToHSV,
            CIERGBToHSV.pathId:            CIERGBToHSV,
            AdobeWideGamutRGBToHSV.pathId: AdobeWideGamutRGBToHSV,

            sRGBToHSL.pathId:              sRGBToHSL,
            AppleRGBToHSL.pathId:          AppleRGBToHSL,
            AdobeRGBToHSL.pathId:          AdobeRGBToHSL,
            BT2020RGBToHSL.pathId:         BT2020RGBToHSL,
            BT709RGBToHSL.pathId:          BT709RGBToHSL,
            DCIP3RGBToHSL.pathId:          DCIP3RGBToHSL,
            DCIP3PRGBToHSL.pathId:         DCIP3PRGBToHSL,
            DisplayP3RGBToHSL.pathId:      DisplayP3RGBToHSL,
            CIERGBToHSL.pathId:            CIERGBToHSL,
            AdobeWideGamutRGBToHSL.pathId: AdobeWideGamutRGBToHSL,

            sRGBToCMY.pathId:              sRGBToCMY,
            AppleRGBToCMY.pathId:          AppleRGBToCMY,
            AdobeRGBToCMY.pathId:          AdobeRGBToCMY,
            BT2020RGBToCMY.pathId:         BT2020RGBToCMY,
            BT709RGBToCMY.pathId:          BT709RGBToCMY,
            DCIP3RGBToCMY.pathId:          DCIP3RGBToCMY,
            DCIP3PRGBToCMY.pathId:         DCIP3PRGBToCMY,
            DisplayP3RGBToCMY.pathId:      DisplayP3RGBToCMY,
            CIERGBToCMY.pathId:            CIERGBToCMY,
            AdobeWideGamutRGBToCMY.pathId: AdobeWideGamutRGBToCMY
        ]
        
        public static let sRGBToXYZ: PathConverter = .init( .sRGB ==> .XYZ ) {
            let color = $0.base as! sRGB
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.sRGBToXYZ(color: color, illuminant: illuminant, infos: infos)
            )
        }
        
        public static let AppleRGBToXYZ: PathConverter = .init( .AppleRGB ==> .XYZ ) {
            let color = $0.base as! AppleRGB
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.AppleRGBToXYZ(color: color, illuminant: illuminant, infos: infos)
            )
        }
        
        public static let AdobeRGBToXYZ: PathConverter = .init( .AdobeRGB ==> .XYZ ) {
            let color = $0.base as! AdobeRGB
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.AdobeRGBToXYZ(color: color, illuminant: illuminant, infos: infos)
            )
        }
        
        public static let BT2020RGBToXYZ: PathConverter = .init( .BT2020RGB ==> .XYZ ) {
            let color = $0.base as! BT2020RGB
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.BT2020RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
            )
        }
        
        public static let BT709RGBToXYZ: PathConverter = .init( .BT709RGB ==> .XYZ ) {
            let color = $0.base as! BT709RGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.BT709RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let DCIP3RGBToXYZ: PathConverter = .init( .DCIP3RGB ==> .XYZ ) {
            let color = $0.base as! DCIP3RGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.DCIP3RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let DCIP3PRGBToXYZ: PathConverter = .init( .DCIP3PRGB ==> .XYZ ) {
            let color = $0.base as! DCIP3PRGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.DCIP3PRGBToXYZ(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let DisplayP3RGBToXYZ: PathConverter = .init( .DisplayP3RGB ==> .XYZ ) {
            let color = $0.base as! DisplayP3RGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.DisplayP3RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let CIERGBToXYZ: PathConverter = .init( .CIERGB ==> .XYZ ) {
            let color = $0.base as! CIERGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.CIERGBToXYZ(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let AdobeWideGamutRGBToXYZ: PathConverter = .init( .AdobeWideGamutRGB ==> .XYZ ) {
            let color = $0.base as! AdobeWideGamutRGB
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.AdobeWideGamutRGBToXYZ(color: color, illuminant: illuminant, infos: infos)
            )
        }
        
        
        public static let sRGBToHSV: PathConverter = .init( .sRGB ==> .HSV ) {
            .init( Self.sRGBToHSV(color: ($0.base as! sRGB), infos: $1) )
        }
        
        public static let AppleRGBToHSV: PathConverter = .init( .AppleRGB ==> .HSV ) {
            .init( Self.AppleRGBToHSV(color: ($0.base as! AppleRGB), infos: $1) )
        }
        
        public static let AdobeRGBToHSV: PathConverter = .init( .AdobeRGB ==> .HSV ) {
            .init( Self.AdobeRGBToHSV(color: ($0.base as! AdobeRGB), infos: $1) )
        }
        
        public static let BT2020RGBToHSV: PathConverter = .init( .BT2020RGB ==> .HSV ) {
            .init( Self.BT2020RGBToHSV(color: ($0.base as! BT2020RGB), infos: $1) )
        }
        
        public static let BT709RGBToHSV: PathConverter = .init( .BT709RGB ==> .HSV ) {
            .init( Self.BT709RGBToHSV(color: ($0.base as! BT709RGB), infos: $1) )
        }

        public static let DCIP3RGBToHSV: PathConverter = .init( .DCIP3RGB ==> .HSV ) {
            .init( Self.DCIP3RGBToHSV(color: ($0.base as! DCIP3RGB), infos: $1) )
        }

        public static let DCIP3PRGBToHSV: PathConverter = .init( .DCIP3PRGB ==> .HSV ) {
            .init( Self.DCIP3PRGBToHSV(color: ($0.base as! DCIP3PRGB), infos: $1) )
        }

        public static let DisplayP3RGBToHSV: PathConverter = .init( .DisplayP3RGB ==> .HSV ) {
            .init( Self.DisplayP3RGBToHSV(color: ($0.base as! DisplayP3RGB), infos: $1) )
        }

        public static let CIERGBToHSV: PathConverter = .init( .CIERGB ==> .HSV ) {
            .init( Self.CIERGBToHSV(color: ($0.base as! CIERGB), infos: $1) )
        }

        public static let AdobeWideGamutRGBToHSV: PathConverter = .init( .AdobeWideGamutRGB ==> .HSV ) {
            .init( Self.AdobeWideGamutRGBToHSV(color: ($0.base as! AdobeWideGamutRGB), infos: $1) )
        }
        
        
        public static let sRGBToHSL: PathConverter = .init( .sRGB ==> .HSL ) {
            .init( Self.sRGBToHSL(color: ($0.base as! sRGB), infos: $1) )
        }
        
        public static let AppleRGBToHSL: PathConverter = .init( .AppleRGB ==> .HSL ) {
            .init( Self.AppleRGBToHSL(color: ($0.base as! AppleRGB), infos: $1) )
        }
        
        public static let AdobeRGBToHSL: PathConverter = .init( .AdobeRGB ==> .HSL ) {
            .init( Self.AdobeRGBToHSL(color: ($0.base as! AdobeRGB), infos: $1) )
        }
        
        public static let BT2020RGBToHSL: PathConverter = .init( .BT2020RGB ==> .HSL ) {
            .init( Self.BT2020RGBToHSL(color: ($0.base as! BT2020RGB), infos: $1) )
        }
        
        public static let BT709RGBToHSL: PathConverter = .init( .BT709RGB ==> .HSL ) {
            .init( Self.BT709RGBToHSL(color: ($0.base as! BT709RGB), infos: $1) )
        }

        public static let DCIP3RGBToHSL: PathConverter = .init( .DCIP3RGB ==> .HSL ) {
            .init( Self.DCIP3RGBToHSL(color: ($0.base as! DCIP3RGB), infos: $1) )
        }

        public static let DCIP3PRGBToHSL: PathConverter = .init( .DCIP3PRGB ==> .HSL ) {
            .init( Self.DCIP3PRGBToHSL(color: ($0.base as! DCIP3PRGB), infos: $1) )
        }

        public static let DisplayP3RGBToHSL: PathConverter = .init( .DisplayP3RGB ==> .HSL ) {
            .init( Self.DisplayP3RGBToHSL(color: ($0.base as! DisplayP3RGB), infos: $1) )
        }

        public static let CIERGBToHSL: PathConverter = .init( .CIERGB ==> .HSL ) {
            .init( Self.CIERGBToHSL(color: ($0.base as! CIERGB), infos: $1) )
        }

        public static let AdobeWideGamutRGBToHSL: PathConverter = .init( .AdobeWideGamutRGB ==> .HSL ) {
            .init( Self.AdobeWideGamutRGBToHSL(color: ($0.base as! AdobeWideGamutRGB), infos: $1) )
        }
        
        
        public static let sRGBToCMY: PathConverter = .init( .sRGB ==> .CMY ) {
            .init( Self.sRGBToCMY(color: ($0.base as! sRGB), infos: $1) )
        }
        
        public static let AppleRGBToCMY: PathConverter = .init( .AppleRGB ==> .CMY ) {
            .init( Self.AppleRGBToCMY(color: ($0.base as! AppleRGB), infos: $1) )
        }
        
        public static let AdobeRGBToCMY: PathConverter = .init( .AdobeRGB ==> .CMY ) {
            .init( Self.AdobeRGBToCMY(color: ($0.base as! AdobeRGB), infos: $1) )
        }
        
        public static let BT2020RGBToCMY: PathConverter = .init( .BT2020RGB ==> .CMY ) {
            .init( Self.BT2020RGBToCMY(color: ($0.base as! BT2020RGB), infos: $1) )
        }
        
        public static let BT709RGBToCMY: PathConverter = .init( .BT709RGB ==> .CMY ) {
            .init( Self.BT709RGBToCMY(color: ($0.base as! BT709RGB), infos: $1) )
        }

        public static let DCIP3RGBToCMY: PathConverter = .init( .DCIP3RGB ==> .CMY ) {
            .init( Self.DCIP3RGBToCMY(color: ($0.base as! DCIP3RGB), infos: $1) )
        }

        public static let DCIP3PRGBToCMY: PathConverter = .init( .DCIP3PRGB ==> .CMY ) {
            .init( Self.DCIP3PRGBToCMY(color: ($0.base as! DCIP3PRGB), infos: $1) )
        }

        public static let DisplayP3RGBToCMY: PathConverter = .init( .DisplayP3RGB ==> .CMY ) {
            .init( Self.DisplayP3RGBToCMY(color: ($0.base as! DisplayP3RGB), infos: $1) )
        }

        public static let CIERGBToCMY: PathConverter = .init( .CIERGB ==> .CMY ) {
            .init( Self.CIERGBToCMY(color: ($0.base as! CIERGB), infos: $1) )
        }

        public static let AdobeWideGamutRGBToCMY: PathConverter = .init( .AdobeWideGamutRGB ==> .CMY ) {
            .init( Self.AdobeWideGamutRGBToCMY(color: ($0.base as! AdobeWideGamutRGB), infos: $1) )
        }
        
    }
}

extension ColorPathSelector.RGBSelector {
    
    // MARK: - to XYZ -
    public static func RGBToXYZ<T: RGBColorable>(color: T, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        
        /// RGB to XYZ conversion. Expects RGB values between 0 and 255.
        /// Based off of: http://www.brucelindbloom.com/index.html?Eqn_RGB_to_XYZ.html

        let downColor = color.downable()
        
        /// - Tag: Will contain linearized RGB channels (removed the gamma func).
        let linearChannels = downColor.eotfDecoding()
        
        /// - Tag: Apply an RGB working space matrix to the XYZ values (matrix mul).
        let _xyz = Parent.applyRGBMatrix(fromRGB: T.init(array: linearChannels))
        let x = _xyz.x
        let y = _xyz.y
        let z = _xyz.z

        let targetIlluminant: Illuminant
        if let illuminant = illuminant {
            targetIlluminant = illuminant
        } else {
            targetIlluminant = color.illuminant
        }

        /// - Tag: The illuminant of the original RGB object. This will always match the RGB colorspace's native illuminant.
        let illuminant = color.illuminant
        var xyz: XYZ = .init(x: x, y: y, z: z, illuminant: illuminant)
        
        /// - Tag: This will take care of any illuminant changes for us (if source illuminant != target illuminant).
        xyz.applyAdaptation(illuminant: targetIlluminant)

        return xyz
        
    }
    
    public static func sRGBToXYZ(color: sRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func AppleRGBToXYZ(color: AppleRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func AdobeRGBToXYZ(color: AdobeRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func BT2020RGBToXYZ(color: BT2020RGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func BT709RGBToXYZ(color: BT709RGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }

    public static func DCIP3RGBToXYZ(color: DCIP3RGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }

    public static func DCIP3PRGBToXYZ(color: DCIP3PRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }

    public static func DisplayP3RGBToXYZ(color: DisplayP3RGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }

    public static func CIERGBToXYZ(color: CIERGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }

    public static func AdobeWideGamutRGBToXYZ(color: AdobeWideGamutRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }
    
    // MARK: - to HSV -
    public static func RGBToHSV<T: RGBColorable>(color: T, infos: [AnyHashable: Any]?) -> HSV {
        
        /// Converts from RGB to HSV.
        ///
        /// H values are in degrees and are 0 to 1.0.
        /// S values are a percentage, 0.0 to 1.0.
        /// V values are a percentage, 0.0 to 1.0.

        let downColor = color.downable()
        
        let r = downColor.red
        let g = downColor.green
        let b = downColor.blue

        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)

        let h = __RGBToHue(red: r, green: g, blue: b, min: min, max: max)

        let s: Element
        if max == 0 {
            s = 0
        } else {
            s = 1.0 - (min / max)
        }

        let v = max

        return .init(h: h / 360.0, s: s, v: v, illuminant: color.illuminant)
        
    }
    
    public static func sRGBToHSV(color: sRGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }
    
    public static func AppleRGBToHSV(color: AppleRGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }
    
    public static func AdobeRGBToHSV(color: AdobeRGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }
    
    public static func BT2020RGBToHSV(color: BT2020RGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }
    
    public static func BT709RGBToHSV(color: BT709RGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }

    public static func DCIP3RGBToHSV(color: DCIP3RGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }

    public static func DCIP3PRGBToHSV(color: DCIP3PRGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }

    public static func DisplayP3RGBToHSV(color: DisplayP3RGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }

    public static func CIERGBToHSV(color: CIERGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }

    public static func AdobeWideGamutRGBToHSV(color: AdobeWideGamutRGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }
    
    // MARK: - to HSL -
    public static func RGBToHSL<T: RGBColorable>(color: T, infos: [AnyHashable: Any]?) -> HSL {
        
        /// Converts from RGB to HSL.
        ///
        /// H values are in degrees and are 0 to 1.0.
        /// S values are a percentage, 0.0 to 1.0.
        /// L values are a percentage, 0.0 to 1.0.
 
        let downColor = color.downable()
        
        let r = downColor.red
        let g = downColor.green
        let b = downColor.blue

        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)

        let h = __RGBToHue(red: r, green: g, blue: b, min: min, max: max)
        let l = 0.5 * (max + min)

        let s: Element
        if max == min {
            s = 0
        } else if l <= 0.5 {
            s = (max - min) / (2.0 * l)
        } else {
            s = (max - min) / (2.0 - (2.0 * l))
        }

        return .init(h: h / 360.0, s: s, l: l, illuminant: color.illuminant)
        
    }
    
    public static func sRGBToHSL(color: sRGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }
    
    public static func AppleRGBToHSL(color: AppleRGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }
    
    public static func AdobeRGBToHSL(color: AdobeRGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }
    
    public static func BT2020RGBToHSL(color: BT2020RGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }
    
    public static func BT709RGBToHSL(color: BT709RGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }

    public static func DCIP3RGBToHSL(color: DCIP3RGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }

    public static func DCIP3PRGBToHSL(color: DCIP3PRGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }

    public static func DisplayP3RGBToHSL(color: DisplayP3RGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }

    public static func CIERGBToHSL(color: CIERGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }

    public static func AdobeWideGamutRGBToHSL(color: AdobeWideGamutRGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }
    
    // MARK: - to CMY -
    public static func RGBToCMY<T: RGBColorable>(color: T, infos: [AnyHashable: Any]?) -> CMY {
    
        let downColor = color.downable()
        
        let r = downColor.red
        let g = downColor.green
        let b = downColor.blue
        
        /// NOTE: CMYK and CMY values range from 0.0 to 1.0
        let c = 1.0 - r
        let m = 1.0 - g
        let y = 1.0 - b

        return .init(c: c, m: m, y: y, illuminant: color.illuminant)
        
    }
    
    public static func sRGBToCMY(color: sRGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }
    
    public static func AppleRGBToCMY(color: AppleRGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }
    
    public static func AdobeRGBToCMY(color: AdobeRGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }
    
    public static func BT2020RGBToCMY(color: BT2020RGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }
    
    public static func BT709RGBToCMY(color: BT709RGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }

    public static func DCIP3RGBToCMY(color: DCIP3RGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }

    public static func DCIP3PRGBToCMY(color: DCIP3PRGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }

    public static func DisplayP3RGBToCMY(color: DisplayP3RGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }

    public static func CIERGBToCMY(color: CIERGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }

    public static func AdobeWideGamutRGBToCMY(color: AdobeWideGamutRGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }
    
}

extension ColorPathSelector.RGBSelector {
    
    /// For RGBToHSL and RGBToHSV, the Hue (H) component is calculated in the same way.
    public static func __RGBToHue(red: Element, green: Element, blue: Element, min: Element, max: Element) -> Element {
        
        guard max != min else { return 0 }
        
        if max == red {
            return (
                60.0 * ((green - blue) / (max - min)) + 360
            ).truncatingRemainder(dividingBy: 360.0)
        }
        
        if max == green {
            return 60.0 * ((blue - red) / (max - min)) + 120
        }
        
        if max == blue {
            return 60.0 * ((red - green) / (max - min)) + 240.0
        }
        
        return 0
    }
    
}
