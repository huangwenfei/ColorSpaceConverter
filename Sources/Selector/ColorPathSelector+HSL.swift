//
//  ColorPathSelector+HSL.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    public struct HSLSelector {
        
        public typealias Parent = ColorPathSelector
        public typealias Element = Parent.Element
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            tosRGB.pathId:              tosRGB,
            toAppleRGB.pathId:          toAppleRGB,
            toAdobeRGB.pathId:          toAdobeRGB,
            toBT2020RGB.pathId:         toBT2020RGB,
            toBT709RGB.pathId:          toBT709RGB,
            toDCIP3RGB.pathId:          toDCIP3RGB,
            toDCIP3PRGB.pathId:         toDCIP3PRGB,
            toDisplayP3RGB.pathId:      toDisplayP3RGB,
            toCIERGB.pathId:            toCIERGB,
            toAdobeWideGamutRGB.pathId: toAdobeWideGamutRGB
        ]
        
        public static let tosRGB: PathConverter = .init( .HSL ==> .sRGB ) {
            .init( Self.tosRGB(color: ($0.base as! HSL), infos: $1) )
        }
        
        public static let toAppleRGB: PathConverter = .init( .HSL ==> .AppleRGB ) {
            .init( Self.toAppleRGB(color: ($0.base as! HSL), infos: $1) )
        }
        
        public static let toAdobeRGB: PathConverter = .init( .HSL ==> .AdobeRGB ) {
            .init( Self.toAdobeRGB(color: ($0.base as! HSL), infos: $1) )
        }
        
        public static let toBT2020RGB: PathConverter = .init( .HSL ==> .BT2020RGB ) {
            .init( Self.toBT2020RGB(color: ($0.base as! HSL), infos: $1) )
        }
        
        public static let toBT709RGB: PathConverter = .init( .HSL ==> .BT709RGB ) {
            .init( Self.toBT709RGB(color: ($0.base as! HSL), infos: $1) )
        }

        public static let toDCIP3RGB: PathConverter = .init( .HSL ==> .DCIP3RGB ) {
            .init( Self.toDCIP3RGB(color: ($0.base as! HSL), infos: $1) )
        }

        public static let toDCIP3PRGB: PathConverter = .init( .HSL ==> .DCIP3PRGB ) {
            .init( Self.toDCIP3PRGB(color: ($0.base as! HSL), infos: $1) )
        }

        public static let toDisplayP3RGB: PathConverter = .init( .HSL ==> .DisplayP3RGB ) {
            .init( Self.toDisplayP3RGB(color: ($0.base as! HSL), infos: $1) )
        }

        public static let toCIERGB: PathConverter = .init( .HSL ==> .CIERGB ) {
            .init( Self.toCIERGB(color: ($0.base as! HSL), infos: $1) )
        }

        public static let toAdobeWideGamutRGB: PathConverter = .init( .HSL ==> .AdobeWideGamutRGB ) {
            .init( Self.toAdobeWideGamutRGB(color: ($0.base as! HSL), infos: $1) )
        }
        
    }
}

extension ColorPathSelector.HSLSelector {
    
    public static func toRGB<R: RGBColorable>(color: HSL, infos: [AnyHashable: Any]?) -> R {
        
        /// HSL to RGB conversion.
        ///
        /// H values are in degrees and are 0 to 1.0.
        /// S values are a percentage, 0.0 to 1.0.
        /// V values are a percentage, 0.0 to 1.0.
        ///
        
        let downable = color.downable()
        
        let h = downable.h
        let s = downable.s
        let l = downable.l

        let varQ: Element
        if l < 0.5 {
            varQ = l * (1.0 + s)
        } else {
            varQ = l + s - (l * s)
        }

        let varP = 2.0 * l - varQ

        /// - Tag: H normalized to range `[0,1]`
        let hSubK = h // h / 360.0

        let tSubR = hSubK + (1.0 / 3.0)
        let tSubG = hSubK
        let tSubB = hSubK - (1.0 / 3.0)

        let r = __CalcHSLToRGBComponents(q: varQ, p: varP, C: tSubR)
        let g = __CalcHSLToRGBComponents(q: varQ, p: varP, C: tSubG)
        let b = __CalcHSLToRGBComponents(q: varQ, p: varP, C: tSubB)

        return .init(
            red: r, green: g, blue: b,
            illuminant: color.illuminant,
            isUpscale: false
        )
        
    }
    
    public static func tosRGB(color: HSL, infos: [AnyHashable: Any]?) -> sRGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toAppleRGB(color: HSL, infos: [AnyHashable: Any]?) -> AppleRGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toAdobeRGB(color: HSL, infos: [AnyHashable: Any]?) -> AdobeRGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toBT2020RGB(color: HSL, infos: [AnyHashable: Any]?) -> BT2020RGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toBT709RGB(color: HSL, infos: [AnyHashable: Any]?) -> BT709RGB {
        toRGB(color: color, infos: infos)
    }

    public static func toDCIP3RGB(color: HSL, infos: [AnyHashable: Any]?) -> DCIP3RGB {
        toRGB(color: color, infos: infos)
    }

    public static func toDCIP3PRGB(color: HSL, infos: [AnyHashable: Any]?) -> DCIP3PRGB {
        toRGB(color: color, infos: infos)
    }

    public static func toDisplayP3RGB(color: HSL, infos: [AnyHashable: Any]?) -> DisplayP3RGB {
        toRGB(color: color, infos: infos)
    }

    public static func toCIERGB(color: HSL, infos: [AnyHashable: Any]?) -> CIERGB {
        toRGB(color: color, infos: infos)
    }

    public static func toAdobeWideGamutRGB(color: HSL, infos: [AnyHashable: Any]?) -> AdobeWideGamutRGB {
        toRGB(color: color, infos: infos)
    }
    
}

extension ColorPathSelector.HSLSelector {
    
    /// This is used in toRGB conversions on R, G, and B.
    public static func __CalcHSLToRGBComponents(q: Element, p: Element, C: Element) -> Element {

        var C = C
        if C < 0 { C += 1.0 }
        if C > 1 { C -= 1.0 }

        /// - Tag: Computing C of vector (Color R, Color G, Color B)
        if C < (1.0 / 6.0) {
            return p + ((q - p) * 6.0 * C)
        } else if (1.0 / 6.0) <= C && C < 0.5 {
            return q
        } else if 0.5 <= C && C < (2.0 / 3.0) {
            return p + ((q - p) * 6.0 * ((2.0 / 3.0) - C))
        } else {
            return p
        }
        
    }
    
}
