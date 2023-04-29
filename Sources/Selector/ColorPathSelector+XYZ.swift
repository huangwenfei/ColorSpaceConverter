//
//  ColorPathSelector+XYZ.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation
import Accelerate

extension ColorPathSelector {
    public struct XYZSelector {
        
        public typealias Parent = ColorPathSelector
        public typealias Element = Parent.Element
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            toxyY.pathId:               toxyY,
            toLuv.pathId:               toLuv,
            toLab.pathId:               toLab,
            
            tosRGB.pathId:              tosRGB,
            toAppleRGB.pathId:          toAppleRGB,
            toAdobeRGB.pathId:          toAdobeRGB,
            toBT2020RGB.pathId:         toBT2020RGB,
            toBT709RGB.pathId:          toBT709RGB,
            toDCIP3RGB.pathId:          toDCIP3RGB,
            toDCIP3PRGB.pathId:         toDCIP3PRGB,
            toDisplayP3RGB.pathId:      toDisplayP3RGB,
            toCIERGB.pathId:            toCIERGB,
            toAdobeWideGamutRGB.pathId: toAdobeWideGamutRGB,
            toIPT.pathId:               toIPT
        ]
        
        public static let toxyY: PathConverter = .init( .XYZ ==> .xyY ) {
            .init( Self.toxyY(color: ($0.base as! XYZ), infos: $1) )
        }
        
        public static let toLuv: PathConverter = .init( .XYZ ==> .Luv ) {
            .init( Self.toLuv(color: ($0.base as! XYZ), infos: $1) )
        }
        
        public static let toLab: PathConverter = .init( .XYZ ==> .Lab ) {
            .init( Self.toLab(color: ($0.base as! XYZ), infos: $1) )
        }
        
        public static let tosRGB: PathConverter = .init( .XYZ ==> .sRGB ) {
            let color = $0.base as! XYZ
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.tosRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
        
        public static let toAppleRGB: PathConverter = .init( .XYZ ==> .AppleRGB ) {
            let color = $0.base as! XYZ
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.toAppleRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
        
        public static let toAdobeRGB: PathConverter = .init( .XYZ ==> .AdobeRGB ) {
            let color = $0.base as! XYZ
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.toAdobeRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
        
        public static let toBT2020RGB: PathConverter = .init( .XYZ ==> .BT2020RGB ) {
            let color = $0.base as! XYZ
            var infos = $1
            let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
            infos?["\(Illuminant.self)"] = nil
            return .init(
                Self.toBT2020RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
        
        public static let toBT709RGB: PathConverter = .init( .XYZ ==> .BT709RGB ) {
            let color = $0.base as! XYZ
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toBT709RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let toDCIP3RGB: PathConverter = .init( .XYZ ==> .DCIP3RGB ) {
            let color = $0.base as! XYZ
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toDCIP3RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let toDCIP3PRGB: PathConverter = .init( .XYZ ==> .DCIP3PRGB ) {
            let color = $0.base as! XYZ
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toDCIP3PRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let toDisplayP3RGB: PathConverter = .init( .XYZ ==> .DisplayP3RGB ) {
            let color = $0.base as! XYZ
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toDisplayP3RGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let toCIERGB: PathConverter = .init( .XYZ ==> .CIERGB ) {
            let color = $0.base as! XYZ
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toCIERGB(color: color, illuminant: illuminant, infos: infos)
            )
        }

        public static let toAdobeWideGamutRGB: PathConverter = .init( .XYZ ==> .AdobeWideGamutRGB ) {
            let color = $0.base as! XYZ
            var infos = $1
            let illuminant = infos?["Illuminant"] as! Illuminant
            infos?["Illuminant"] = nil
            return .init(
                Self.toAdobeWideGamutRGB(color: color, illuminant: illuminant, infos: infos)
            )
        }
        
        public static let toIPT: PathConverter = .init( .XYZ ==> .IPT ) {
            .init( Self.toIPT(color: ($0.base as! XYZ), infos: $1) )
        }
        
    }
}

extension ColorPathSelector.XYZSelector {
    
    public static func toxyY(color: XYZ, infos: [AnyHashable: Any]?) -> xyY {
        
        let xyzSum = color.elements.reduce(0) { $0 + $1 }
        
        /// - Tag: avoid division by zero
        let x: xyY.Element
        let y: xyY.Element
        if xyzSum == 0 {
            x = 0
            y = 0
        } else {
            x = color.x / xyzSum
            y = color.y / xyzSum
        }
        
        let Y = color.y

        return .init(
            x: x, y: y, Y: Y, illuminant: color.illuminant
        )
    
    }
    
    public static func toLuv(color: XYZ, infos: [AnyHashable: Any]?) -> Luv {
        
        let tempX = color.x
        var tempY = color.y
        let tempZ = color.z
        let denom = tempX + (15 * tempY) + (3 * tempZ)
        
        /// - Tag: avoid division by zero
        var u: Luv.Element
        var v: Luv.Element
        if denom == 0 {
            u = 0
            v = 0
        } else {
            u = (4 * tempX) / denom
            v = (9 * tempY) / denom
        }

        let illum = color.illuminant.lamp.xyz
        
        tempY = tempY / illum.y
        if tempY > DeltaE.e {
            tempY = pow(tempY, (1 / 3))
        } else {
            tempY = (7.787 * tempY) + (16 / 116)
        }

        let refU = (4 * illum.x) / (illum.x + (15 * illum.y) + (3 * illum.z))
        let refV = (9 * illum.y) / (illum.x + (15 * illum.y) + (3 * illum.z))

        let l = (116 * tempY) - 16
        u = 13 * l * (u - refU)
        v = 13 * l * (v - refV)

        return .init(
            l: l, u: u, v: v, illuminant: color.illuminant
        )
    
    }
    
    public static func toLab(color: XYZ, infos: [AnyHashable: Any]?) -> Lab {
        
        func clamp(_ v: Element) -> Element {
            if v > DeltaE.e {
                return pow(v, (1.0 / 3.0))
            } else {
                return (7.787 * v) + (16.0 / 116.0)
            }
        }
        
        let illum = color.illuminant.lamp.xyz
        
        let tempX = clamp(color.x / illum.x)
        let tempY = clamp(color.y / illum.y)
        let tempZ = clamp(color.z / illum.z)

        let l = (116 * tempY) - 16
        let a = 500 * (tempX - tempY)
        let b = 200 * (tempY - tempZ)
        return .init(
            l: l, a: a, b: b, illuminant: color.illuminant
        )
    
    }
    
    public static func toRGB<R: RGBColorable>(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> R {
        
        var tempX = color.x
        var tempY = color.y
        var tempZ = color.z
        
        /// - Tag: If the XYZ values were taken with a different reference white than the native reference white of the target RGB space, a transformation matrix must be applied.
        if color.illuminant != illuminant {
            /// - Tag: Get the adjusted XYZ values, adapted for the target illuminant.
            ChromaticAdaptation.adaptation(
                x: &tempX, y: &tempY, z: &tempZ,
                xyzIlluminant: color.illuminant, illuminant: illuminant
            )
        }
        
        /// - Tag: Apply an RGB working space matrix to the XYZ values (matrix mul).
        var rgb: R = Parent.applyRGBMatrix(fromXYZ: [tempX, tempY, tempZ])

        /// - Tag: V
        let nonlinearChannels = rgb.eotfEncoding()

        rgb.red = min(max(nonlinearChannels[0], R.redDownerRange.min), R.redDownerRange.max)
        rgb.green = min(max(nonlinearChannels[1], R.greenDownerRange.min), R.greenDownerRange.max)
        rgb.blue = min(max(nonlinearChannels[2], R.blueDownerRange.min), R.blueDownerRange.max)
        rgb.illuminant = illuminant
        rgb.isUpscale = false
        
        return rgb
    
    }
    
    public static func tosRGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> sRGB {
        toRGB(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func toAppleRGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> AppleRGB {
        toRGB(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func toAdobeRGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> AdobeRGB {
        toRGB(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func toBT2020RGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> BT2020RGB {
        toRGB(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func toBT709RGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> BT709RGB {
        toRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toDCIP3RGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> DCIP3RGB {
        toRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toDCIP3PRGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> DCIP3PRGB {
        toRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toDisplayP3RGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> DisplayP3RGB {
        toRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toCIERGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> CIERGB {
        toRGB(color: color, illuminant: illuminant, infos: infos)
    }

    public static func toAdobeWideGamutRGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> AdobeWideGamutRGB {
        toRGB(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func toIPT(color: XYZ, infos: [AnyHashable: Any]?) -> IPT {

        /// NOTE: XYZ values need to be adapted to 2 degree D65

        /** Reference:
         Fairchild, M. D. (2013). Color appearance models, 3rd Ed. (pp. 271-272).
         John Wiley & Sons.
        */

        guard color.illuminant == .two(.d65) else {
            #if DEBUG
            fatalError("XYZColor for XYZ->IPT conversion needs to be D65 adapted.")
            #else
            return .init()
            #endif
        }
        
        let transMatrix = IPT.xyzToLmsMatrices

        let xyzValues = color.elements
        let valueM = xyzValues.count
        let valueN = 1
        
        var lmsValues = Math.mul(
            mat1: transMatrix,
            mat2: .init(xyzValues, valueM, valueN)
        ).values

        #if true
//        var signLmsValues = lmsValues.map { sign($0) }
        var signLmsValues = Math.sign(lmsValues)
        #else
        /// - Tag: Get the zero elements from lmsValues.
        var ones = [Element](repeating: 1, count: lmsValues.count)
        var oneZeros = [Element](repeating: 0, count: ones.count)
        vDSP_vmulD(
            &ones, vDSP_Stride(1),
            &lmsValues, vDSP_Stride(1),
            &oneZeros, vDSP_Stride(1),
            vDSP_Length(oneZeros.count)
        )
        
        /// - Tag: Copy Signs from lmsValues to oneZeros.
        var signCount: Int32 = .init(lmsValues.count)
        var signLmsValues = [Element](repeating: 0, count: lmsValues.count)
        vvcopysign(&signLmsValues, &oneZeros, &lmsValues, &signCount)
        
        #endif
        
        var lmsCount: Int32 = .init(lmsValues.count)
        var absLmsValues = [Element](repeating: 0, count: lmsValues.count)
        vvfabs(&absLmsValues, &lmsValues, &lmsCount)
        
        var lmsPrimeTemp = [Element](repeating: 0, count: lmsValues.count)
        vDSP_vmulD(
            &signLmsValues, vDSP_Stride(1),
            &absLmsValues, vDSP_Stride(1),
            &lmsPrimeTemp, vDSP_Stride(1),
            vDSP_Length(lmsPrimeTemp.count)
        )
        
        var exponents = [Element](repeating: 0.43, count: lmsValues.count)
        
        var lmsPrime = [Element](repeating: 0, count: lmsValues.count)
        vvpow(&lmsPrime, &exponents, &lmsPrimeTemp, &lmsCount)
        
        let lmsToIptMat = IPT.lmstoIptMatrices
        
        /// `3 X 3 * 3 X 1`
        let iptValues = Math.mul(
            mat1: lmsToIptMat,
            mat2: .init(lmsPrime, lmsPrime.count, 1)
        ).values
        
        return .init(array: iptValues)
        
    }
    
}
