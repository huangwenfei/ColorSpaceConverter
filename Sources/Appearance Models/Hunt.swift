//
//  Hunt.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2021/1/11.
//  Copyright © 2021 黄文飞. All rights reserved.
//

import Foundation

///**
// *   Fairchild, M. D. (2013). *Color appearance models*, 3rd Ed. John Wiley & Sons.
// *   Hunt, R. W. G. (2005). *The reproduction of colour*. 5th Ed., John Wiley & Sons.
// */
//public struct Hunt {
//
//    public var hueAngle: Double
//    public var chroma: Double
//    public var saturation: Double
//    public var brightness: Double
//
//    public var colorfulness: Double
//
//    public var lightness: Double
//
//    public init(
//        x: Double,
//        y: Double,
//        z: Double,
//        xb: Double,
//        yb: Double,
//        zb: Double,
//        xw: Double,
//        yw: Double,
//        zw: Double,
//        la: Double,
//        nc: Double,
//        nb: Double,
//        las: Double? = nil,
//        cctw: Double? = nil,
//        ncb: Double? = nil,
//        nbb: Double? = nil,
//        xp: Double? = nil,
//        yp: Double? = nil,
//        zp: Double? = nil,
//        p: Double? = nil,
//        helsonJudd: Bool = false,
//        discountIlluminant: Bool = true,
//        s_sw: (s: Double, sw: Double)? = nil
//    ) {
//
////        :param x: X value of test sample :math:`X`.
////        :param y: Y value of test sample :math:`Y`.
////        :param z: Z value of test sample :math:`Z`.
////        :param x_b: X value of background :math:`X_b`.
////        :param y_b: Y value of background :math:`Y_b`.
////        :param z_b: Z value of background :math:`Z_b`.
////        :param x_w: X value of reference white :math:`X_W`.
////        :param y_w: Y value of reference white :math:`Y_W`.
////        :param z_w: Z value of reference white :math:`Z_W`.
////        :param l_a: Adapting luminance :math:`L_A`.
////        :param n_c: Chromatic surround induction_factor :math:`N_c`.
////        :param n_b: Brightness surround induction factor :math:`N_b`.
////        :param l_as: Scotopic luminance of the illuminant :math:`L_{AS}`.
////                     Will be approximated if not supplied.
////        :param cct_w: Correlated color temperature of illuminant :math:`T`.
////                      Will be used to approximate l_as if not supplied.
////        :param n_cb: Chromatic background induction factor :math:`N_{cb}`.
////                     Will be approximated using y_w and y_b if not supplied.
////        :param n_bb: Brightness background induction factor :math:`N_{bb}`.
////                     Will be approximated using y_w and y_b if not supplied.
////        :param x_p: X value of proxima field :math:`X_p`.
////                    If not supplied, will be assumed to equal background.
////        :param y_p: Y value of proxima field :math:`Y_p`.
////                    If not supplied, will be assumed to equal background.
////        :param z_p: Z value of proxima field :math:`Z_p`.
////                    If not supplied, will be assumed to equal background.
////        :param p: Simultaneous contrast/assimilation parameter.
////        :param helson_judd: Truth value indicating whether the Heslon-Judd effect
////                            should be accounted for.
////                            Default False.
////        :param discount_illuminant: Truth value whether discount-the-illuminant
////                                    should be applied. Default True.
////        :param s: Scotopic response to the stimulus.
////        :param s_w: Scotopic response for th reference white.
////        :raises ValueError: if illegal parameter combination is supplied.
//
//        let xp = xp != nil ? xp! : xb
//        let yp = yp != nil ? yp! : yb
//        let zp = zp != nil ? zp! : zb
//
//        let ncb = ncb != nil ? ncb! : (0.725 * pow((yw / yb), 0.2))
//        let nbb = nbb != nil ? nbb! : (0.725 * pow((yw / yb), 0.2))
//
//        let cctw = cctw != nil ? cctw! : Self.getCct(x: xw, y: yw, z: zw)
//        let las = las != nil
//            ? las!
//            : ((2.26 * la) * pow(((cctw / 4000) - 0.4), (1 / 3)))
//
//        let (s, sw) = s_sw != nil ? (s_sw!.s, s_sw!.sw) : (y, yw)
//
//        let p = p != nil ? p! : 0
//
//        let xyz = (x, y, z)
//        let xyzw = (xw, yw, zw)
//
//        let xyzb = (xb, yb, zb)
//        let xyzp = (xp, yp, zp)
//
//        let k = 1 / (5 * la + 1)
//
//        /// - Tag: luminance adaptation factor
//        let fl = 0.2
//            * pow(k, 4)
//            * (5 * la)
//            + 0.1 * pow(1 - pow(k, 4), 2) * pow(5 * la, 1 / 3)
//
//        let (ra, ga, ba) = Self.adaptation(
//            fl: fl, la: la,
//            xyz: xyz, xyzw: xyzw, xyzb: xyzb, xyzp: xyzp,
//            p: p,
//            helsonJudd: helsonJudd,
//            discountIlluminant: discountIlluminant
//        )
//
//        let (raw, gaw, baw) = Self.adaptation(
//            fl: fl, la: la,
//            xyz: xyzw, xyzw: xyzw, xyzb: xyzb, xyzp: xyzp,
//            p: p,
//            helsonJudd: helsonJudd,
//            discountIlluminant: discountIlluminant
//        )
//
//        /// - Tag: Opponent Color Dimensions
//
//        /// achromaticConeSignal
//        let aa = 2 * ra + ga + (1 / 20) * ba - 3.05 + 1
//
//        let aaw = 2 * raw + gaw + (1 / 20) * baw - 3.05 + 1
//
//        let c1 = ra - ga
//        let c2 = ga - ba
//        let c3 = ba - ra
//
//        let c1w = raw - gaw
//        let c2w = gaw - baw
//        let c3w = baw - raw
//
//        /// - Tag: Hue
//        hueAngle = (
//            180 * atan2(0.5 * (c2 - c3) / 4.5, c1 - (c2 / 11)) / .pi
//        ).truncatingRemainder(dividingBy: 360)
//        let hueAnglew = (
//            180
//            * atan2(0.5 * (c2w - c3w) / 4.5, c1w - (c2w / 11))
//            / .pi
//        ).truncatingRemainder(dividingBy: 360)
//
//        /// - Tag: Saturation
//        let es = Self.calculateEccentricityFactor(hueAngle: hueAngle)
//        let esw = Self.calculateEccentricityFactor(hueAngle: hueAnglew)
//
//        let ft = la / (la + 0.1)
//
//        let myb = 100 * (0.5 * (c2 - c3) / 4.5) * (es * (10 / 13) * nc * ncb * ft)
//
//        let mrg = 100 * (c1 - (c2 / 11)) * (es * (10 / 13) * nc * ncb)
//
//        let m = pow((pow(mrg, 2) + pow(myb, 2)), 0.5)
//
//        saturation = 50 * m / (ra + ga + ba)
//
//        let mybw = (
//            100 * (0.5 * (c2w - c3w) / 4.5) * (esw * (10 / 13) * nc * ncb * ft)
//        )
//        let mrgw = 100 * (c1w - (c2w / 11)) * (esw * (10 / 13) * nc * ncb)
//        let mw = pow((pow(mrgw, 2) + pow(mybw, 2)), 0.5)
//
//        /// - Tag: Brightness
//        let a = Self.calculateAchromaticSignal(
//            las: las, s: s, sw: sw, nbb: nbb, aa: aa
//        )
//
//        let aw = Self.calculateAchromaticSignal(
//            las: las, s: sw, sw: sw, nbb: nbb, aa: aaw
//        )
//
//        let n1 = pow((7 * aw), 0.5) / pow(5.33 * nb, 0.13)
//        let n2 = pow(7 * aw * nb, 0.362) / 200
//
//        brightness = pow(7 * (a + (m / 100)), 0.6) * n1 - n2
//        let brightnessw = pow(7 * (aw + (mw / 100)), 0.6) * n1 - n2
//
//        /// - Tag: Lightness
//        let z = 1 + pow(yb / yw, 0.5)
//
//        lightness = 100 * pow(brightness / brightnessw, z)
//
//        /// - Tag: Chroma
//        chroma = (
//            2.44
//            * pow(saturation, 0.69)
//            * pow(brightness / brightnessw, yb / yw)
//            * pow(1.64 - 0.29, yb / yw)
//        )
//
//        /// - Tag: Colorfulness
//        colorfulness = pow(fl, 0.15) * chroma
//
//    }
//
//    private static let xyzToRgbMat: ColorElement.Matrix = (
//        [
//            0.38971, 0.68898, -0.07868,
//            -0.22981, 1.18340, 0.04641,
//            0, 0, 1
//        ],
//        3, 3
//    )
//
//    private static func xyzToRgb(xyz: [Double]) -> [Double] {
//        Math.mul(
//            mat1: xyzToRgbMat, vector: (xyz, xyz.count)
//        ).values
//    }
//
//    private static func adaptation(
//        fl: Double,
//        la: Double,
//        xyz: [Double],
//        xyzw: [Double],
//        xyzb: [Double],
//        xyzp: [Double]? = nil,
//        p: Double? = nil,
//        helsonJudd: Bool = false,
//        discountIlluminant: Bool = true
//    ) -> (Double, Double, Double) {
//
////        :param f_l: Luminance adaptation factor
////        :param l_a: Adapting luminance
////        :param xyz: Stimulus color in XYZ
////        :param xyz_w: Reference white color in XYZ
////        :param xyz_b: Background color in XYZ
////        :param xyz_p: Proxima field color in XYZ
////        :param p: Simultaneous contrast/assimilation parameter.
//
//        let rgb  = xyzToRgb(xyz: xyz)
//        var rgbw = xyzToRgb(xyz: xyzw)
//
//        let yw = xyzw[1]
//        let yb = xyzb[1]
//
//        var hrgbTemp = Math.mul(&rgbw, 3)
//        let hrgb = Math.div(&hrgbTemp, Math.sum(rgbw))
//
//        /// - Tag: Chromatic adaptation factors
//        let frgb: Double
//        if !discountIlluminant {
//            frgb = (1 + pow(la, (1 / 3)) + hrgb) / (
//                1 + pow(la, (1 / 3)) + (1 / hrgb)
//            )
//        } else {
//            frgb = numpy.ones(numpy.shape(hrgb))
//        }
//
//        /// - Tag: Adaptation factor
//        let drgb: Double
//        if helsonJudd {
//            drgb = fn((yb / yw) * fl * frgb.1) - fn(
//                (yb / yw) * fl * frgb
//            )
////            assert drgb[1] == 0
//        } else {
//            drgb = numpy.zeros(numpy.shape(frgb))
//        }
//
//        /// - Tag: Cone bleaching factors
//        let rgbb = (10 ** 7) / ((10 ** 7) + 5 * la * (rgbw / 100))
//
//        if let xyzp = xyzp, let p = p {
//            rgbp = xyzToRgb(xyz: xyzp)
//            rgbw = adjustWhiteForScc(rgbp, rgbb, rgbw, p)
//        }
//
//        /// - Tag: Adapt rgb using modified
//        rgba = 1 + rgbb * (fn(fl * frgb * rgb / rgbw) + drgb)
//
//        return rgba
//    }
//
//    private static func adjustWhiteForScc(rgbp: [Double], rgbb: [Double], rgbw: [Double], p: Double) -> Double {
//
////        Adjust the white point for simultaneous chromatic contrast.
////
////        :param rgb_p: Cone signals of proxima field.
////        :param rgb_b: Cone signals of background.
////        :param rgb_w: Cone signals of reference white.
////        :param p: Simultaneous contrast/assimilation parameter.
////        :return: Adjusted cone signals for reference white.
//
//        let prgb = rgbp / rgbb
//        let result = (
//            rgbw
//            * (((1 - p) * prgb + (1 + p) / prgb) ** 0.5)
//            / (((1 + p) * prgb + (1 - p) / prgb) ** 0.5)
//        )
//        return result
//    }
//
//    private static func getCct(x: Double, y: Double, z: Double) -> Double {
//
////        Reference
////        Hernandez-Andres, J., Lee, R. L., & Romero, J. (1999).
////        Calculating correlated color temperatures across the entire gamut of daylight
////        and skylight chromaticities.
////        Applied Optics, 38(27), 5703-5709.
//
//        let xe = 0.3320
//        let ye = 0.1858
//
//        let n = ((x / (x + z + z)) - xe) / ((y / (x + z + z)) - ye)
//
//        let a0 = -949.86315
//        let a1 = 6253.80338
//        let a2 = 28.70599
//        let a3 = 0.00004
//
//        let t1 = 0.92159
//        let t2 = 0.20039
//        let t3 = 0.07125
//
//        let cct = (
//            a0
//            + a1 * exp(-n / t1)
//            + a2 * exp(-n / t2)
//            + a3 * exp(-n / t3)
//        )
//        return cct
//    }
//
//    private static func calculateScotopicLuminance(photopicLuminance: Double, colorTemperature: Double) -> Double {
//        2.26 * photopicLuminance * ((colorTemperature / 4000) - 0.4) ** (1 / 3)
//    }
//
//    private static func calculateAchromaticSignal(las: Double, s: Double, sw: Double, nbb: Double, aa: Double) -> Double {
//
//        let j = 0.00001 / ((5 * las / 2.26) + 0.00001)
//
//        let fls = 3800 * (j ** 2) * (5 * las / 2.26)
//        let fls += 0.2 * ((1 - (j ** 2)) ** 0.4) * ((5 * las / 2.26) ** (1 / 6))
//
//        let bs = 0.5 / (1 + 0.3 * ((5 * las / 2.26) * (s / sw)) ** 0.3)
//        let bs += 0.5 / (1 + 5 * (5 * las / 2.26))
//
//        let `as` = (fn(fls * s / sw) * 3.05 * bs) + 0.3
//
//        return nbb * (aa - 1 + `as` - 0.3 + sqrt((1 + (0.3 ** 2))))
//    }
//
//    private static func fn(i: Double) -> Double {
////        Nonlinear response function.
//        40 * ((i ** 0.73) / (i ** 0.73 + 2))
//    }
//
//    private static func calculateEccentricityFactor(hueAngle: Double) -> Double {
//
//        let h = [20.14, 90, 164.25, 237.53]
//        let e = [0.8, 0.7, 1.0, 1.2]
//
//        let out = interp(hueAngle, h, e)
//        let out = numpy.where(hueAngle < 20.14, 0.856 - (hueAngle / 20.14) * 0.056, out)
//        let out = numpy.where(
//            hueAngle > 237.53, 0.856 + 0.344 * (360 - hueAngle) / (360 - 237.53), out
//        )
//
//        return out
//    }
//
//}
