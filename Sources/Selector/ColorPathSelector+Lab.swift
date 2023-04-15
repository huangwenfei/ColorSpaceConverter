//
//  ColorPathSelector+Lab.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    public struct LabSelector {
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            toLCHab.pathId: toLCHab,
            toXYZ.pathId:   toXYZ
        ]
        
        public static let toLCHab: PathConverter = .init( .Lab ==> .LCHab ) {
            .init( Self.toLCHab(color: ($0.base as! Lab), infos: $1) )
        }
        
        public static let toXYZ: PathConverter = .init( .Lab ==> .XYZ ) {
            .init( Self.toXYZ(color: ($0.base as! Lab), infos: $1) )
        }
        
    }
}

extension ColorPathSelector.LabSelector {
    
    /// Convert from CIE Lab to LCH(ab).
    public static func toLCHab(color: Lab, infos: [AnyHashable: Any]?) -> LCHab {
        
        let l = color.l
        let a = sqrt(pow(color.a, 2) + pow(color.b, 2))
        var b = atan2(color.b, color.a)

        if b > 0 {
            b = (b / .pi) * 180
        } else {
            b = 360 - (fabs(b) / .pi) * 180
        }
        
        return .init(
            l: l, a: a, b: b, illuminant: color.illuminant
        )
        
    }
    
    public static func toXYZ(color: Lab, infos: [AnyHashable: Any]?) -> XYZ {
        
        let illum = color.illuminant.lamp.xyz
        var y = (color.l + 16.0) / 116.0
        var x = color.a / 500.0 + y
        var z = y - color.b / 200.0

        if pow(y, 3) > DeltaE.e {
            y = pow(y, 3)
        } else {
            y = (y - 16.0 / 116.0) / 7.787
        }
        
        if pow(x, 3) > DeltaE.e {
            x = pow(x, 3)
        } else {
            x = (x - 16.0 / 116.0) / 7.787
        }

        if pow(z, 3) > DeltaE.e {
            z = pow(z, 3)
        } else {
            z = (z - 16.0 / 116.0) / 7.787
        }
        
        x = illum.x * x
        y = illum.y * y
        z = illum.z * z

        return .init(
            x: x, y: y, z: z, illuminant: color.illuminant
        )
    
    }
    
}
