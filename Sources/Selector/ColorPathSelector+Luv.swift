//
//  ColorPathSelector+Luv.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    public struct LuvSelector {
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            toLCHuv.pathId: toLCHuv,
            toXYZ.pathId:   toXYZ
        ]
        
        public static let toLCHuv: PathConverter = .init( .Luv ==> .LCHuv ) {
            .init( Self.toLCHuv(color: ($0.base as! Luv), infos: $1) )
        }
        
        public static let toXYZ: PathConverter = .init( .Luv ==> .XYZ ) {
            .init( Self.toXYZ(color: ($0.base as! Luv), infos: $1) )
        }
        
    }
}

extension ColorPathSelector.LuvSelector {
    
    /// Convert from CIE Luv to LCH(uv).
    public static func toLCHuv(color: Luv, infos: [AnyHashable: Any]?) -> LCHuv {
        
        let l = color.l
        let u = sqrt(pow(color.u, 2) + pow(color.v, 2.0))
        var v = atan2(color.v, color.u)

        if v > 0 {
            v = (v / .pi) * 180
        } else {
            v = 360 - (fabs(v) / .pi) * 180
        }
        
        return .init(
            l: l, u: u, v: v, illuminant: color.illuminant
        )
    
    }
    
    public static func toXYZ(color: Luv, infos: [AnyHashable: Any]?) -> XYZ {
        
        let illum = color.illuminant.lamp.xyz
        
        /// - Tag: Without Light, there is no color. Short-circuit this and avoid some zero division errors in the `var_a_frac` calculation.
        guard color.l > 0.0 else {
            return .init(
                x: 0, y: 0, z: 0, illuminant: color.illuminant
            )
        }

        /// - Tag: Various variables used throughout the conversion.
        let cieKTimesE = DeltaE.k * DeltaE.e
        let uSub0 = (4 * illum.x) / (illum.x + 15 * illum.y + 3 * illum.z)
        let vSub0 = (9 * illum.y) / (illum.x + 15 * illum.y + 3 * illum.z)
        let u = color.u / (13 * color.l) + uSub0
        let v = color.v / (13 * color.l) + vSub0

        /// - Tag: Y-coordinate calculations.
        let y: XYZ.Element
        if color.l > cieKTimesE {
            y = pow((color.l + 16) / 116, 3)
        } else {
            y = color.l / DeltaE.e
        }
            
        /// - Tag: X-coordinate calculation.
        let x = y * 9 * u / (4 * v)
        
        /// - Tag: Z-coordinate calculation.
        let z = y * (12 - 3 * u - 20 * v) / (4 * v)

        return .init(
            x: x, y: y, z: z, illuminant: color.illuminant
        )
    
    }
    
}
