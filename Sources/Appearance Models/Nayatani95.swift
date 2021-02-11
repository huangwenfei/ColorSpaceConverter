//
//  Nayatani95.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2021/1/11.
//  Copyright © 2021 黄文飞. All rights reserved.
//

import Foundation

/**
 *   Fairchild, M. D. (2013). *Color appearance models*, 3rd Ed. John Wiley & Sons.
 *   Nayatani, Y., Sobagaki, H., & Yano, K. H. T. (1995). Lightness dependency of
     chroma scales of a nonlinear color-appearance model and its latest formulation.
     *Color Research & Application*, 20(3), 156-167.
 */

public struct Nayatani95 {
    
    public var hueAngle: Double = 0
    public var chroma: Double = 0
    public var saturation: Double = 0
    public var brightness: Double = 0

    public var colorfulness: Double = 0
    
    public private(set) var achromaticResponse: Double = 0
    public private(set) var tritanopicResponse: Double = 0
    public private(set) var protanopicResponse: Double = 0
    
    public private(set) var brightnessIdealWhite: Double = 0
    
    public private(set) var lightnessAchromatic: Double = 0
    public private(set) var lightnessAchromaticNormalized: Double = 0
    
    public private(set) var saturationRg: Double = 0
    public private(set) var saturationYb: Double = 0

    public private(set) var chromaRg: Double = 0
    public private(set) var chromaYb: Double = 0
    
    public private(set) var colorfulnessRg: Double = 0
    public private(set) var colorfulnessYb: Double = 0
    
    private init() { }
    
    public init(
        x: Double, y: Double, z: Double,
        xn: Double, yn: Double, zn: Double,
        yob: Double, eo: Double, eor: Double, n: Double = 1
    ) {
         
//         :param x: X value of test sample :math:`X`.
//         :param y: Y value of test sample :math:`Y`.
//         :param z: Z value of test sample :math:`Z`.
//         :param x_n: X value of reference white :math:`X_n`.
//         :param y_n: Y value of reference white :math:`Y_n`.
//         :param z_n: Z value of reference white :math:`Z_n`.
//         :param y_ob: Luminance factor of achromatic background as percentage :math:`Y_o`.
//                      Required to be larger than 0.18.
//         :param e_o: Illuminance of the viewing field :math:`E_o` in lux.
//         :param e_or: Normalising illuminance :math:`E_or` in lux.
//         :param n: Noise term :math:`n`.
         
        self.init()

        guard yob > 0.18 else {
            #if DEBUG
            fatalError("y_ob has be greater than 0.18.")
            #else
            return
            #endif
        }

        let _ = yob * eo / (100 * .pi)
        let lor = yob * eor / (100 * .pi)

        let xo = xn / (xn + yn + zn)
        let yo = yn / (xn + yn + zn)

        let xi = (0.48105 * xo + 0.78841 * yo - 0.08081) / yo
        let eta = (-0.27200 * xo + 1.11962 * yo + 0.04570) / yo
        let zeta = (0.91822 * (1 - xo - yo)) / yo

        let rgb_ = ((yob * eo) / (100 * .pi))
        let r0 = rgb_ * xi
        let g0 = rgb_ * eta
        let b0 = rgb_ * zeta

        let (r, g, b) = Self.xyzToRgb(xyz: (x, y, z))

        let er = Self.computeScalingCoefficient(a: r, b: xi)
        let eg = Self.computeScalingCoefficient(a: g, b: eta)

        let betaR = Self.beta1(x: r0)
        let betaG = Self.beta1(x: g0)
        let betaB = Self.beta2(x: b0)

        let betaL = Self.beta1(x: lor)
        
        /// - Tag: Opponent Color Dimension
        achromaticResponse = (
            (2 / 3) * betaR * er * log10((r + n) / (20 * xi + n))
        )
        achromaticResponse += (
            (1 / 3) * betaG * eg * log10((g + n) / (20 * eta + n))
        )
        achromaticResponse *= 41.69 / betaL

        tritanopicResponse = (
            (1 / 1) * betaR * log10((r + n) / (20 * xi + n))
        )
        tritanopicResponse += (
            -(12 / 11) * betaG * log10((g + n) / (20 * eta + n))
        )
        tritanopicResponse += (
            (1 / 11) * betaB * log10((b + n) / (20 * zeta + n))
        )
        
        protanopicResponse = (
            (1 / 9) * betaR * log10((r + n) / (20 * xi + n))
        )
        protanopicResponse += (
            (1 / 9) * betaG * log10((g + n) / (20 * eta + n))
        )
        protanopicResponse += (
            -(2 / 9) * betaB * log10((b + n) / (20 * zeta + n))
        )

        /// - Tag: Brightness
        brightness = (50 / betaL) * (
            (2 / 3) * betaR + (1 / 3) * betaG
        ) + achromaticResponse

        brightnessIdealWhite = (
            (2 / 3) * betaR * 1.758 * log10((100 * xi + n) / (20 * xi + n))
        )
        brightnessIdealWhite += (
            (1 / 3) * betaG * 1.758 * log10((100 * eta + n) / (20 * eta + n))
        )
        brightnessIdealWhite *= 41.69 / betaL
        brightnessIdealWhite += (50 / betaL) * (2 / 3) * betaR
        brightnessIdealWhite += (50 / betaL) * (1 / 3) * betaG

        /// - Tag: Lightness
        lightnessAchromatic = achromaticResponse + 50
        lightnessAchromaticNormalized = 100 * (
            brightness / brightnessIdealWhite
        )

        /// - Tag: Hue
        let hueAngleRad = atan2(protanopicResponse, tritanopicResponse)
        hueAngle = (
            (360 * hueAngleRad / (2 * .pi)) + 360
        ).truncatingRemainder(dividingBy: 360)

        let esTheta = Self.chromaticStrength(angle: hueAngleRad)

        /// - Tag: Saturation
        saturationRg = (488.93 / betaL) * esTheta * tritanopicResponse
        saturationYb = (488.93 / betaL) * esTheta * protanopicResponse

        saturation = sqrt(pow(saturationRg, 2) + pow(saturationYb, 2))
        
        /// - Tag: Chroma
        chromaRg = pow((lightnessAchromatic / 50), 0.7) * saturationRg
        chromaYb = pow((lightnessAchromatic / 50), 0.7) * saturationYb
        chroma   = pow((lightnessAchromatic / 50), 0.7) * saturation

        /// - Tag: Colorfulness
        colorfulnessRg = chromaRg * brightnessIdealWhite / 100
        colorfulnessYb = chromaYb * brightnessIdealWhite / 100
        colorfulness   = chroma * brightnessIdealWhite / 100

    }
        
    private static func chromaticStrength(angle: Double) -> Double {
         var result = 0.9394
         result += -0.2478 * sin(1 * angle)
         result += -0.0743 * sin(2 * angle)
         result += +0.0666 * sin(3 * angle)
         result += -0.0186 * sin(4 * angle)
         result += -0.0055 * cos(1 * angle)
         result += -0.0521 * cos(2 * angle)
         result += -0.0573 * cos(3 * angle)
         result += -0.0061 * cos(4 * angle)
         return result
    }

    private static func computeScalingCoefficient(a: Double, b: Double) -> Double {
        a >= (20 * b) ? 1.758 : 1
    }

    private static func beta1(x: Double) -> Double {
        (6.469 + 6.362 * pow(x, 0.4495)) / (6.469 + pow(x, 0.4495))
    }

    private static func beta2(x: Double) -> Double {
        0.7844 * (8.414 + 8.091 * pow(x, 0.5128)) / (8.414 + pow(x, 0.5128))
    }

    private static var xyzToRgbM: Math.Matrix = (
        [
            0.40024, 0.70760, -0.08081,
            -0.22630, 1.16532, 0.04570,
            0, 0, 0.91822
        ],
        3, 3
    )

    private static func xyzToRgb(xyz: (Double, Double, Double)) -> (Double, Double, Double) {
        let rgb = Math.mul(
            mat1: xyzToRgbM, vector: ([xyz.0, xyz.1, xyz.2], 3)
        )
        return (rgb.values[0], rgb.values[1], rgb.values[2])
    }
    
}

