//
//  ColorSpaceConverterTests.swift
//  ColorSpaceConverterTests
//
//  Created by 黄文飞 on 2020/12/28.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import XCTest

import ColorSpaceConverter

class ColorSpaceConverterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func format(_ v: Double) -> Double {
        atof(Array(String(format: "%0.4f", v).utf8CString))
    }
    
    func formatInt(_ v: Double) -> Int {
        .init(round(atof(Array(String(format: "%0.4f", v).utf8CString))))
    }
    
    func formatRound(_ v: Double) -> Double {
        atof(Array(String(format: "%0.0f", round(v)).utf8CString))
    }
    
    func testsHexInit() throws {
        /// - Tag: init(hex: String)
        /// case 1: 16 bits
        /// (red: 5 /*85*/, green: 2 /*34*/, blue: 11 /*187*/)
        XCTAssertTrue(Hex(byString: "52B").description == "#5522BBFF")
        XCTAssertTrue(Hex(byString: "#52B").description == "#5522BBFF")
        XCTAssertTrue(Hex(byString: "0x52B").description == "#5522BBFF")
        XCTAssertTrue(Hex(byString: "0X52B").description == "#5522BBFF")
        XCTAssertTrue(Hex(byString: "52BF").description == "#5522BBFF")
        /// case 2: 32 bits
        /// (red: 88, green: 38, blue: 182)
        XCTAssertTrue(Hex(byString: "5522BB").description == "#5522BBFF")
        XCTAssertTrue(Hex(byString: "#5522BB").description == "#5522BBFF")
        XCTAssertTrue(Hex(byString: "0x5522BB").description == "#5522BBFF")
        XCTAssertTrue(Hex(byString: "0X5522BB").description == "#5522BBFF")
        XCTAssertTrue(Hex(byString: "5522BBFF").description == "#5522BBFF")
    }
    
    func testsHexFromxRGB() throws {
        let srgb = sRGB(red: 88, green: 38, blue: 182)
        let hex = Hex(rgb: srgb)
        XCTAssertTrue(hex.red == srgb.red)
        XCTAssertTrue(hex.green == srgb.green)
        XCTAssertTrue(hex.blue == srgb.blue)
        ///
        let applergb = AppleRGB(red: 88, green: 38, blue: 182)
        let applehex = Hex(rgb: applergb)
        XCTAssertTrue(applehex.red == applergb.red)
        XCTAssertTrue(applehex.green == applergb.green)
        XCTAssertTrue(applehex.blue == applergb.blue)
        ///
        let adobergb = AdobeRGB(red: 88, green: 38, blue: 182)
        let adobehex = Hex(rgb: adobergb)
        XCTAssertTrue(adobehex.red == adobergb.red)
        XCTAssertTrue(adobehex.green == adobergb.green)
        XCTAssertTrue(adobehex.blue == adobergb.blue)
        ///
        let bt2020rgb = AdobeRGB(red: 88, green: 38, blue: 182)
        let bt2020hex = Hex(rgb: bt2020rgb)
        XCTAssertTrue(bt2020hex.red == bt2020rgb.red)
        XCTAssertTrue(bt2020hex.green == bt2020rgb.green)
        XCTAssertTrue(bt2020hex.blue == bt2020rgb.blue)
    }
    
    func testsxRGBToHex() throws {
        ///
        let rgb = sRGB(red: 88, green: 38, blue: 182)
        var hex = Converter.convert(from: rgb, to: Hex.self)
        XCTAssertTrue(format(hex.red) == 88)
        XCTAssertTrue(format(hex.green) == 38)
        XCTAssertTrue(format(hex.blue) == 182)
        XCTAssertTrue(format(hex.alpha) == 255)
        ///
        let rgb1 = AppleRGB(red: 88, green: 38, blue: 182)
        hex = Converter.convert(from: rgb1, to: Hex.self)
        XCTAssertTrue(format(hex.red) == 88)
        XCTAssertTrue(format(hex.green) == 38)
        XCTAssertTrue(format(hex.blue) == 182)
        XCTAssertTrue(format(hex.alpha) == 255)
        ///
        let rgb2 = AppleRGB(red: 88, green: 38, blue: 182)
        hex = Converter.convert(from: rgb2, to: Hex.self)
        XCTAssertTrue(format(hex.red) == 88)
        XCTAssertTrue(format(hex.green) == 38)
        XCTAssertTrue(format(hex.blue) == 182)
        XCTAssertTrue(format(hex.alpha) == 255)
        ///
        let rgb3 = AppleRGB(red: 88, green: 38, blue: 182)
        hex = Converter.convert(from: rgb3, to: Hex.self)
        XCTAssertTrue(format(hex.red) == 88)
        XCTAssertTrue(format(hex.green) == 38)
        XCTAssertTrue(format(hex.blue) == 182)
        XCTAssertTrue(format(hex.alpha) == 255)
    }
    
    func testsHexToxRGB() throws {
        /// (red: 5 /*85*/, green: 2 /*34*/, blue: 11 /*187*/)
        let hex = Hex(byString: "5522BB")
        /// case 1: to srgb
        let srgb = Converter.convert(from: hex, to: sRGB.self).uppable()
        XCTAssertTrue(formatRound(srgb.red) == 85)
        XCTAssertTrue(formatRound(srgb.green) == 34)
        XCTAssertTrue(formatRound(srgb.blue) == 187)
        /// case 1: to srgb
        let applergb = Converter.convert(from: hex, to: AppleRGB.self).uppable()
        XCTAssertTrue(formatRound(applergb.red) == 63)
        XCTAssertTrue(formatRound(applergb.green) == 15)
        XCTAssertTrue(formatRound(applergb.blue) == 176)
        /// case 1: to srgb
        let adobergb = Converter.convert(from: hex, to: AdobeRGB.self).uppable()
        XCTAssertTrue(formatRound(adobergb.red) == 76)
        XCTAssertTrue(formatRound(adobergb.green) == 39)
        XCTAssertTrue(formatRound(adobergb.blue) == 182)
        /// case 1: to srgb
        let bt2020rgb = Converter.convert(from: hex, to: BT2020RGB.self).uppable()
        XCTAssertTrue(formatRound(bt2020rgb.red) == 67)
        XCTAssertTrue(formatRound(bt2020rgb.green) == 30)
        XCTAssertTrue(formatRound(bt2020rgb.blue) == 170)
    }
    
    func testsRgbToX() throws {
        let rgb = sRGB(red: 88, green: 38, blue: 182)
        /// case 1: to hsl
        let hsl = Converter.convert(from: rgb, to: HSL.self)
        XCTAssertTrue(format(hsl.h) == 0.7245)
        XCTAssertTrue(format(hsl.s) == 0.6545)
        XCTAssertTrue(format(hsl.l) == 0.4314)
        /// case 2: to hsb/v
        let hsv = Converter.convert(from: rgb, to: HSV.self)
        XCTAssertTrue(format(hsv.h) == 0.7245)
        XCTAssertTrue(format(hsv.s) == 0.7912)
        XCTAssertTrue(format(hsv.v) == 0.7137)
        /// case 3: to cmy
        let cmy = Converter.convert(from: rgb, to: CMY.self)
        XCTAssertTrue(format(cmy.c) == 0.6549)
        XCTAssertTrue(format(cmy.m) == 0.8510)
        XCTAssertTrue(format(cmy.y) == 0.2863)
        /// case 4: to cmyk
        let cmyk = Converter.convert(from: rgb, to: CMYK.self)
        XCTAssertTrue(format(cmyk.c) == 0.5165)
        XCTAssertTrue(format(cmyk.m) == 0.7912)
        XCTAssertTrue(format(cmyk.y) == 0.0)
        XCTAssertTrue(format(cmyk.k) == 0.2863)
        /// case 5: to xyz
        let xyz = Converter.convert(from: rgb, to: XYZ.self)
        XCTAssertTrue(format(xyz.x) == 0.1316)
        XCTAssertTrue(format(xyz.y) == 0.0684)
        XCTAssertTrue(format(xyz.z) == 0.4488)
    }

    func testAppleRgbToX() throws {
        let rgb = AppleRGB(red: 88, green: 38, blue: 182)
        /// case 1: to hsl
        let hsl = Converter.convert(from: rgb, to: HSL.self)
        XCTAssertTrue(format(hsl.h) == 0.7245)
        XCTAssertTrue(format(hsl.s) == 0.6545)
        XCTAssertTrue(format(hsl.l) == 0.4314)
        /// case 2: to hsb/v
        let hsv = Converter.convert(from: rgb, to: HSV.self)
        XCTAssertTrue(format(hsv.h) == 0.7245)
        XCTAssertTrue(format(hsv.s) == 0.7912)
        XCTAssertTrue(format(hsv.v) == 0.7137)
        /// case 3: to cmy
        let cmy = Converter.convert(from: rgb, to: CMY.self)
        XCTAssertTrue(format(cmy.c) == 0.6549)
        XCTAssertTrue(format(cmy.m) == 0.8510)
        XCTAssertTrue(format(cmy.y) == 0.2863)
        /// case 4: to cmyk
        let cmyk = Converter.convert(from: rgb, to: CMYK.self)
        XCTAssertTrue(format(cmyk.c) == 0.5165)
        XCTAssertTrue(format(cmyk.m) == 0.7912)
        XCTAssertTrue(format(cmyk.y) == 0.0)
        XCTAssertTrue(format(cmyk.k) == 0.2863)
        /// case 5: to xyz
        let xyz = Converter.convert(from: rgb, to: XYZ.self)
        XCTAssertTrue(format(xyz.x) == 0.1771)
        XCTAssertTrue(format(xyz.y) == 0.1033)
        XCTAssertTrue(format(xyz.z) == 0.5110)
    }
    
    func testAdobeRgbToX() throws {
        let rgb = AdobeRGB(red: 88, green: 38, blue: 182)
        /// case 1: to hsl
        let hsl = Converter.convert(from: rgb, to: HSL.self)
        XCTAssertTrue(format(hsl.h) == 0.7245)
        XCTAssertTrue(format(hsl.s) == 0.6545)
        XCTAssertTrue(format(hsl.l) == 0.4314)
        /// case 2: to hsb/v
        let hsv = Converter.convert(from: rgb, to: HSV.self)
        XCTAssertTrue(format(hsv.h) == 0.7245)
        XCTAssertTrue(format(hsv.s) == 0.7912)
        XCTAssertTrue(format(hsv.v) == 0.7137)
        /// case 3: to cmy
        let cmy = Converter.convert(from: rgb, to: CMY.self)
        XCTAssertTrue(format(cmy.c) == 0.6549)
        XCTAssertTrue(format(cmy.m) == 0.8510)
        XCTAssertTrue(format(cmy.y) == 0.2863)
        /// case 4: to cmyk
        let cmyk = Converter.convert(from: rgb, to: CMYK.self)
        XCTAssertTrue(format(cmyk.c) == 0.5165)
        XCTAssertTrue(format(cmyk.m) == 0.7912)
        XCTAssertTrue(format(cmyk.y) == 0.0)
        XCTAssertTrue(format(cmyk.k) == 0.2863)
        /// case 5: to xyz
        let xyz = Converter.convert(from: rgb, to: XYZ.self)
        print(xyz)
        XCTAssertTrue(format(xyz.x) == 0.1480)
        XCTAssertTrue(format(xyz.y) == 0.0740)
        XCTAssertTrue(format(xyz.z) == 0.4758)
    }
    
    func testBT2020RgbToX() throws {
        let rgb = BT2020RGB(red: 88, green: 38, blue: 182)
        /// case 1: to hsl
        let hsl = Converter.convert(from: rgb, to: HSL.self)
        XCTAssertTrue(format(hsl.h) == 0.7245)
        XCTAssertTrue(format(hsl.s) == 0.6545)
        XCTAssertTrue(format(hsl.l) == 0.4314)
        /// case 2: to hsb/v
        let hsv = Converter.convert(from: rgb, to: HSV.self)
        XCTAssertTrue(format(hsv.h) == 0.7245)
        XCTAssertTrue(format(hsv.s) == 0.7912)
        XCTAssertTrue(format(hsv.v) == 0.7137)
        /// case 3: to cmy
        let cmy = Converter.convert(from: rgb, to: CMY.self)
        XCTAssertTrue(format(cmy.c) == 0.6549)
        XCTAssertTrue(format(cmy.m) == 0.8510)
        XCTAssertTrue(format(cmy.y) == 0.2863)
        /// case 4: to cmyk
        let cmyk = Converter.convert(from: rgb, to: CMYK.self)
        XCTAssertTrue(format(cmyk.c) == 0.5165)
        XCTAssertTrue(format(cmyk.m) == 0.7912)
        XCTAssertTrue(format(cmyk.y) == 0.0)
        XCTAssertTrue(format(cmyk.k) == 0.2863)
        /// case 5: to xyz
        // TODO: ???
        let xyz = Converter.convert(from: rgb, to: XYZ.self)
        XCTAssertTrue(format(xyz.x) == 0.1767)
        XCTAssertTrue(format(xyz.y) == 0.0902)
        XCTAssertTrue(format(xyz.z) == 0.5436)
    }
    
    func testHSLTosRgb() throws {
        let color = HSL(h: 0.7245, s: 0.6545, l: 0.4314)
        /// case 1: to sRgb
        let srgb = Converter.convert(from: color, to: sRGB.self).uppable()
        XCTAssertTrue(formatInt(srgb.red) == 88)
        XCTAssertTrue(formatInt(srgb.green) == 38)
        XCTAssertTrue(formatInt(srgb.blue) == 182)
        /// case 2: to appleRgb
        let appleRgb = Converter.convert(from: color, to: AppleRGB.self).uppable()
        XCTAssertTrue(formatInt(appleRgb.red) == 88)
        XCTAssertTrue(formatInt(appleRgb.green) == 38)
        XCTAssertTrue(formatInt(appleRgb.blue) == 182)
        /// case 3: to adobeRgb
        let adobeRgb = Converter.convert(from: color, to: AdobeRGB.self).uppable()
        XCTAssertTrue(formatInt(adobeRgb.red) == 88)
        XCTAssertTrue(formatInt(adobeRgb.green) == 38)
        XCTAssertTrue(formatInt(adobeRgb.blue) == 182)
        /// case 4: to bt2020
        let bt2020Rgb = Converter.convert(from: color, to: BT2020RGB.self).uppable()
        XCTAssertTrue(formatInt(bt2020Rgb.red) == 88)
        XCTAssertTrue(formatInt(bt2020Rgb.green) == 38)
        XCTAssertTrue(formatInt(bt2020Rgb.blue) == 182)
    }
    
    func testHSVTosRgb_() throws {
        let color = HSV(h: 0.33430797733061496, s: 0, v: 87/100)
        /// case 1: to sRgb
        let srgb = Converter.convert(from: color, to: sRGB.self).uppable()
        print(srgb)
        XCTAssertTrue(formatInt(srgb.red) == 222)
        XCTAssertTrue(formatInt(srgb.green) == 222)
        XCTAssertTrue(formatInt(srgb.blue) == 222)
    }
    
    func testHSVTosRgb() throws {
        let color = HSV(h: 0.7245, s: 0.7912, v: 0.7137)
        /// case 1: to sRgb
        let srgb = Converter.convert(from: color, to: sRGB.self).uppable()
        XCTAssertTrue(formatInt(srgb.red) == 88)
        XCTAssertTrue(formatInt(srgb.green) == 38)
        XCTAssertTrue(formatInt(srgb.blue) == 182)
        /// case 2: to appleRgb
        let appleRgb = Converter.convert(from: color, to: AppleRGB.self).uppable()
        XCTAssertTrue(formatInt(appleRgb.red) == 88)
        XCTAssertTrue(formatInt(appleRgb.green) == 38)
        XCTAssertTrue(formatInt(appleRgb.blue) == 182)
        /// case 3: to adobeRgb
        let adobeRgb = Converter.convert(from: color, to: AdobeRGB.self).uppable()
        XCTAssertTrue(formatInt(adobeRgb.red) == 88)
        XCTAssertTrue(formatInt(adobeRgb.green) == 38)
        XCTAssertTrue(formatInt(adobeRgb.blue) == 182)
        /// case 4: to bt2020
        let bt2020Rgb = Converter.convert(from: color, to: BT2020RGB.self).uppable()
        XCTAssertTrue(formatInt(bt2020Rgb.red) == 88)
        XCTAssertTrue(formatInt(bt2020Rgb.green) == 38)
        XCTAssertTrue(formatInt(bt2020Rgb.blue) == 182)
    }
    
    func testCMYTosRgb() throws {
        let color = CMY(c: 0.6549, m: 0.8510, y: 0.2863)
        /// case 1: to sRgb
        let srgb = Converter.convert(from: color, to: sRGB.self).uppable()
        XCTAssertTrue(formatInt(srgb.red) == 88)
        XCTAssertTrue(formatInt(srgb.green) == 38)
        XCTAssertTrue(formatInt(srgb.blue) == 182)
        /// case 2: to appleRgb
        let appleRgb = Converter.convert(from: color, to: AppleRGB.self).uppable()
        XCTAssertTrue(formatInt(appleRgb.red) == 88)
        XCTAssertTrue(formatInt(appleRgb.green) == 38)
        XCTAssertTrue(formatInt(appleRgb.blue) == 182)
        /// case 3: to adobeRgb
        let adobeRgb = Converter.convert(from: color, to: AdobeRGB.self).uppable()
        XCTAssertTrue(formatInt(adobeRgb.red) == 88)
        XCTAssertTrue(formatInt(adobeRgb.green) == 38)
        XCTAssertTrue(formatInt(adobeRgb.blue) == 182)
        /// case 4: to bt2020
        let bt2020Rgb = Converter.convert(from: color, to: BT2020RGB.self).uppable()
        XCTAssertTrue(formatInt(bt2020Rgb.red) == 88)
        XCTAssertTrue(formatInt(bt2020Rgb.green) == 38)
        XCTAssertTrue(formatInt(bt2020Rgb.blue) == 182)
    }
    
    func testXYZTosRgb() throws {
        /// case 1: to sRgb
        var color = XYZ(x: 0.1316, y: 0.0684, z: 0.4488)
        let srgb = Converter.convert(from: color, to: sRGB.self).uppable()
        XCTAssertTrue(formatInt(srgb.red) == 88)
        XCTAssertTrue(formatInt(srgb.green) == 38)
        XCTAssertTrue(formatInt(srgb.blue) == 182)
        /// case 2: to appleRgb
        color = XYZ(x: 0.1771, y: 0.1033, z: 0.5110)
        let appleRgb = Converter.convert(from: color, to: AppleRGB.self).uppable()
        XCTAssertTrue(formatInt(appleRgb.red) == 88)
        XCTAssertTrue(formatInt(appleRgb.green) == 38)
        XCTAssertTrue(formatInt(appleRgb.blue) == 182)
        /// case 3: to adobeRgb
        color = XYZ(x: 0.1480, y: 0.0740, z: 0.4757)
        let adobeRgb = Converter.convert(from: color, to: AdobeRGB.self).uppable()
        XCTAssertTrue(formatInt(adobeRgb.red) == 88)
        XCTAssertTrue(formatInt(adobeRgb.green) == 38)
        XCTAssertTrue(formatInt(adobeRgb.blue) == 182)
        /// case 4: to bt2020
        color = XYZ(x: 0.1767, y: 0.0902, z: 0.5436)
        let bt2020Rgb = Converter.convert(from: color, to: BT2020RGB.self).uppable()
        XCTAssertTrue(formatInt(bt2020Rgb.red) == 88)
        XCTAssertTrue(formatInt(bt2020Rgb.green) == 38)
        XCTAssertTrue(formatInt(bt2020Rgb.blue) == 182)
    }
    
    func testXYZToNewRgbs() {
        
        func to2020<T: RGBColorable>(color: T) {
            let bt2020Rgb = Converter.convert(from: color, to: BT2020RGB.self).uppable()
            print(color.colorSpace, bt2020Rgb)
            XCTAssertTrue(formatInt(bt2020Rgb.red) == 88)
            XCTAssertTrue(formatInt(bt2020Rgb.green) == 38)
            XCTAssertTrue(formatInt(bt2020Rgb.blue) == 182)
        }
        	
        /// case 4: to bt709
        var color = XYZ(x: 0.1767, y: 0.0902, z: 0.5436)
        let bt709Rgb = Converter.convert(from: color, to: BT709RGB.self).uppable()
        print(bt709Rgb)
        XCTAssertTrue(formatInt(bt709Rgb.red) == 113)
        XCTAssertTrue(formatInt(bt709Rgb.green) == 48)
        XCTAssertTrue(formatInt(bt709Rgb.blue) == 227)
        to2020(color: bt709Rgb)
        /// case 4: to DCIP3
        color = XYZ(x: 0.1767, y: 0.0902, z: 0.5436)
        let dcip3Rgb = Converter.convert(from: color, to: DCIP3RGB.self).uppable()
        print(dcip3Rgb)
        XCTAssertTrue(formatInt(dcip3Rgb.red) == 113)
        XCTAssertTrue(formatInt(dcip3Rgb.green) == 48)
        XCTAssertTrue(formatInt(dcip3Rgb.blue) == 227)
        to2020(color: dcip3Rgb)
        /// case 4: to DCIP3P
        color = XYZ(x: 0.1767, y: 0.0902, z: 0.5436)
        let dcip3pRgb = Converter.convert(from: color, to: DCIP3RGB.self).uppable()
        print(dcip3pRgb)
        XCTAssertTrue(formatInt(dcip3pRgb.red) == 113)
        XCTAssertTrue(formatInt(dcip3pRgb.green) == 48)
        XCTAssertTrue(formatInt(dcip3pRgb.blue) == 227)
        to2020(color: dcip3pRgb)
        /// case 4: to Display P3
        color = XYZ(x: 0.1767, y: 0.0902, z: 0.5436)
        let displayP3RGB = Converter.convert(from: color, to: DisplayP3RGB.self).uppable()
        print(displayP3RGB)
        XCTAssertTrue(formatInt(displayP3RGB.red) == 113)
        XCTAssertTrue(formatInt(displayP3RGB.green) == 48)
        XCTAssertTrue(formatInt(displayP3RGB.blue) == 227)
        to2020(color: displayP3RGB)
        /// case 4: to cie rgb
        color = XYZ(x: 0.1767, y: 0.0902, z: 0.5436)
        let cieRgb = Converter.convert(from: color, to: CIERGB.self).uppable()
        print(cieRgb)
        XCTAssertTrue(formatInt(cieRgb.red) == 113)
        XCTAssertTrue(formatInt(cieRgb.green) == 48)
        XCTAssertTrue(formatInt(cieRgb.blue) == 227)
        to2020(color: cieRgb)
        /// case 4: to adobe wide gamut rgb
        color = XYZ(x: 0.1767, y: 0.0902, z: 0.5436)
        let adobeWideGamutRgb = Converter.convert(from: color, to: AdobeWideGamutRGB.self).uppable()
        print(adobeWideGamutRgb)
        XCTAssertTrue(formatInt(adobeWideGamutRgb.red) == 113)
        XCTAssertTrue(formatInt(adobeWideGamutRgb.green) == 48)
        XCTAssertTrue(formatInt(adobeWideGamutRgb.blue) == 227)
        to2020(color: adobeWideGamutRgb)
    }
    
    func testCMYAndCMYK() throws {
        /// cmy -> cmyk
        var cmy = CMY(c: 0.6549, m: 0.8510, y: 0.2863)
        let cmyk = Converter.convert(from: cmy, to: CMYK.self)
        XCTAssertTrue(format(cmyk.c) == 0.5165)
        XCTAssertTrue(format(cmyk.m) == 0.7912)
        XCTAssertTrue(format(cmyk.y) == 0.0)
        XCTAssertTrue(format(cmyk.k) == 0.2863)
        /// cmyk -> cmy
        cmy = Converter.convert(from: cmyk, to: CMY.self)
        XCTAssertTrue(format(cmy.c) == 0.6549)
        XCTAssertTrue(format(cmy.m) == 0.8510)
        XCTAssertTrue(format(cmy.y) == 0.2863)
    }
    
    func testxyYAndXYZ() throws {
        /// XYZ -> xyY
        var xyz = XYZ(x: 0.1316, y: 0.0684, z: 0.4488)
        let xyy = Converter.convert(from: xyz, to: xyY.self)
        XCTAssertTrue(format(xyy.x) == 0.2028)
        XCTAssertTrue(format(xyy.y) == 0.1054)
        XCTAssertTrue(format(xyy.Y) == 0.0684)
        /// xyY -> XYZ
        xyz = Converter.convert(from: xyz, to: XYZ.self)
        XCTAssertTrue(format(xyz.x) == 0.1316)
        XCTAssertTrue(format(xyz.y) == 0.0684)
        XCTAssertTrue(format(xyz.z) == 0.4488)
    }
    
    func testIptAndXyz() throws {
        /// xyz -> ipt
        var xyz = XYZ(x: 0.1316, y: 0.0684, z: 0.4488, illuminant: .two ~ .d65)
        let ipt = Converter.convert(from: xyz, to: IPT.self)
        XCTAssertTrue(format(ipt.i) == 0.3921)
        XCTAssertTrue(format(ipt.p) == 0.0416)
        XCTAssertTrue(format(ipt.t) == -0.4279)
        /// ipt -> xyz
        xyz = Converter.convert(from: xyz, to: XYZ.self)
        XCTAssertTrue(format(xyz.x) == 0.1316)
        XCTAssertTrue(format(xyz.y) == 0.0684)
        XCTAssertTrue(format(xyz.z) == 0.4488)
    }
    
    func testLabAndXyz() throws {
        print()
        /// xyz -> lab
        var xyz = XYZ(x: 0.1316, y: 0.0684, z: 0.4488)
        let lab = Converter.convert(from: xyz, to: Lab.self)
        print(lab)
        XCTAssertTrue(format(lab.l) == 31.4398)
        XCTAssertTrue(format(lab.a) == 54.1872)
        XCTAssertTrue(format(lab.b) == -67.0396)
        print()
        /// lab -> xyz
        xyz = Converter.convert(from: lab, to: XYZ.self)
        print(xyz)
        XCTAssertTrue(format(xyz.x) == 0.1316)
        XCTAssertTrue(format(xyz.y) == 0.0684)
        XCTAssertTrue(format(xyz.z) == 0.4488)
    }
    
    func testLuvAndXyz() throws {
        /// xyz -> luv
        var xyz = XYZ(x: 0.1316, y: 0.0684, z: 0.4488)
        let luv = Converter.convert(from: xyz, to: Luv.self)
        print(luv)
        XCTAssertTrue(format(luv.l) == 31.4398)
        XCTAssertTrue(format(luv.u) == 5.0655)
        XCTAssertTrue(format(luv.v) == -90.9290)
        /// luv -> xyz
        xyz = Converter.convert(from: luv, to: XYZ.self)
        print(xyz)
        XCTAssertTrue(format(xyz.x) == 0.1316)
        XCTAssertTrue(format(xyz.y) == 0.0684)
        XCTAssertTrue(format(xyz.z) == 0.4488)
    }
    
    // TODO: 小数点后第四位精度始终不一样。
    func testLabAndLCHab() throws {
        /// xyz -> luv
        var lab = Lab(l: 31.4398, a: 54.1859, b: -67.0500)
        let lch = Converter.convert(from: lab, to: LCHab.self)
        print(lch)
        XCTAssertTrue(format(lch.l) == 31.4397)
        XCTAssertTrue(format(lch.a) == 86.2082)
        XCTAssertTrue(format(lch.b) == 308.9432)
        /// luv -> xyz
        lab = Converter.convert(from: lch, to: Lab.self)
        print(lab)
        XCTAssertTrue(format(lab.l) == 31.4397)
        XCTAssertTrue(format(lab.a) == 54.1863)
        XCTAssertTrue(format(lab.b) == -67.0503)
    }
    
    // TODO: 小数点后第四位精度始终不一样。
    func testLuvAndLCHuv() throws {
        /// luv -> lchuv
        var luv = Luv(l: 31.4397, u: 5.0615, v: -90.9356)
        let lchuv = Converter.convert(from: luv, to: LCHuv.self)
        print(lchuv)
        XCTAssertTrue(format(lchuv.l) == 31.4396)
        XCTAssertTrue(format(lchuv.u) == 91.0764)
        XCTAssertTrue(format(lchuv.v) == 273.1858)
        /// lchuv -> luv
        luv = Converter.convert(from: lchuv, to: Luv.self)
        print(luv)
        XCTAssertTrue(format(luv.l) == 31.4396)
        XCTAssertTrue(format(luv.u) == 5.0616)
        XCTAssertTrue(format(luv.v) == -90.9357)
    }
    
    func testSpectralToXyz() {
        let spc = Spectral(
            v_380nm: 0.0600,
            v_390nm: 0.0600,
            v_400nm: 0.0641,
            v_410nm: 0.0654,
            v_420nm: 0.0645,
            v_430nm: 0.0605,
            v_440nm: 0.0562,
            v_450nm: 0.0543,
            v_460nm: 0.0537,
            v_470nm: 0.0541,
            v_480nm: 0.0559,
            v_490nm: 0.0603,
            v_500nm: 0.0651,
            v_510nm: 0.0680,
            v_520nm: 0.0705,
            v_530nm: 0.0736,
            v_540nm: 0.0772,
            v_550nm: 0.0809,
            v_560nm: 0.0870,
            v_570nm: 0.0990,
            v_580nm: 0.1128,
            v_590nm: 0.1251,
            v_600nm: 0.1360,
            v_610nm: 0.1439,
            v_620nm: 0.1511,
            v_630nm: 0.1590,
            v_640nm: 0.1688,
            v_650nm: 0.1828,
            v_660nm: 0.1996,
            v_670nm: 0.2187,
            v_680nm: 0.2397,
            v_690nm: 0.2618,
            v_700nm: 0.2852,
            v_710nm: 0.2500,
            v_720nm: 0.2400,
            v_730nm: 0.2300
        )
        let xyz = Converter.convert(from: spc, to: XYZ.self)
        XCTAssertTrue(format(xyz.x) == 0.1083)
        XCTAssertTrue(format(xyz.y) == 0.0968)
        XCTAssertTrue(format(xyz.z) == 0.0621)
    }
    
    func testHslAndLab() {
        /// hsl -> lab
        var hsl = HSL(h: 0.7245, s: 0.6545, l: 0.4314)
        let lab = Converter.convert(from: hsl, to: Lab.self)
        print(lab)
        XCTAssertTrue(format(lab.l) == 31.4344)
        XCTAssertTrue(format(lab.a) == 54.1985)
        XCTAssertTrue(format(lab.b) == -67.0527)
        /// lab -> hsl
        hsl = Converter.convert(from: lab, to: HSL.self)
        print(hsl)
        XCTAssertTrue(format(hsl.h) == 0.7245)
        XCTAssertTrue(format(hsl.s) == 0.6545)
        XCTAssertTrue(format(hsl.l) == 0.4314)
    }
    
    func testLoop() {
        for _ in 0 ..< 100 {
            do {
                try testLabAndXyz()
            } catch {
                
            }
        }
    }
    
    func testExample() throws {
        /*
         hsl = HSLColor(261.0/360.0, 65.0/100.0, 43.0/100.0)
         lab = convert_color(hsl, LabColor)
            output: LabColor (lab_l: 40.3833 lab_a: 55.1400 lab_b: 36.6659)
         */
        let hsl = HSL(h: 261/360, s: 65/100, l: 43/100)
        let lab = Converter.convert(from: hsl, to: Lab.self)
        print(lab) /// Lab(l: 40.38328518018077, a: 55.13998182020166, b: 36.665947952704634, illuminant: Illuminant: [angle: 2˚, lamp: [d65, [0.95047, 1.0, 1.08883]]💡])
    }
    
    func testXyY() throws {
        
        let xy = MathMatrix.init([0.54369557, 0.32107944], 1, 2)
        let xyz = xyY.xy2xyz(xy: xy)
        
        /// [ 1.6933366...,  1.        ,  0.4211574...]
        print(xyz)
        
    }
    
    func testDerivation() throws {
        
        let xy = ColorElement.Matrix.init([0.1, 0.3, 0.4, 0.2, 0.4, 0.1], 3, 2)
        
        let z = Derivation.xy2z(xy: xy)
        
        print("z", z)
        
        XCTAssertTrue(z.rows == 3 && z.columns == 1)
        XCTAssertTrue(z.values == [0.6, 0.3999999999999999, 0.5])
        
        let xyz = Derivation.combineH(xy: xy, z: z)
        
        print("xyz:", xyz)
        
        XCTAssertTrue(xyz.rows == 3 && xyz.columns == 3)
        XCTAssertTrue(xyz.values == [0.1, 0.3, 0.6, 0.4, 0.2, 0.3999999999999999, 0.4, 0.1, 0.5])
        
        let primaries = MathMatrix([0.73470, 0.26530, 0.00000, 1.00000, 0.00010, -0.07700], 3, 2)
        let whitepoint = MathMatrix([0.32168, 0.33767], 1, 2)
        
        let npm = Derivation.normalisedPrimaryMatrix(
            primaries: primaries, whitepoint: whitepoint
        )
        
        /// [  9.5255239...e-01,   0.0000000...e+00,   9.3678631...e-05, 3.4396645...e-01,   7.2816609...e-01,  -7.2132546...e-02, 0.0000000...e+00,   0.0000000...e+00,   1.0088251...e+00 ], 3 , 3
        print("npm: ", npm)
        
    }
    
    func testIlluminant() throws {
        
        /// BT709RGB nonlinear ...
        print(1.099 * pow(0.018, 0.45) - 0.099)
        
        /// Illuminant-A XYZ  (1.09850, 1.00000, 0.35585)
        print(xyY.xy2xyz(xy: .init(values: [0.44758, 0.40745], rows: 1, columns: 2)))
        
        /// Illuminant-f7 XYZ (0.95041, 1.00000, 1.08747)
        print(xyY.xy2xyz(xy: .init(values: [0.31290, 0.32920], rows: 1, columns: 2)))
        
        /// Illuminant-DCI XYZ
        print(xyY.xy2xyz(xy: .init(values: [0.31400, 0.35100], rows: 1, columns: 2)))
        
        print()
        let twoObs: [Illuminant.TwoObserver] = [
            .A, .B, .C,
            .D50, .D55, .D65, .D75,
            .E, .FL2, .FL7, .FL11, .DCI_P3
        ]
        
        twoObs.forEach({
            print("case .\($0):   return Xyz(", xyY.xy2xyz(xy: .init(values: $0.xy, rows: 1, columns: 2)).values)
        })
        print()
        
        print()
        let tenObs: [Illuminant.TenObserver] = [
            .D50, .D55, .D65, .D75
        ]
        
        tenObs.forEach({
            print("case .\($0):   return Xyz(", xyY.xy2xyz(xy: .init(values: $0.xy, rows: 1, columns: 2)).values)
        })
        print()
        
    }
    
    func testXyz2rgbFuncGen() throws {
        
        func xyz2rgbProperty(name: ColorSpaceType.RGB) -> String {
            """
            public static let XYZTo\(name.rawValue): PathConverter = .init( .XYZ ==> .\(name.rawValue) ) {
                let color = $0.base as! XYZ
                var infos = $1
                let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
                infos?["\(Illuminant.self)"] = nil
                return .init(
                    Self.XYZTo\(name.rawValue)(color: color, illuminant: illuminant, infos: infos)
                )
            }
            """
        }
        
        func xyz2rgbFunc(name: ColorSpaceType.RGB) -> String {
            """
            public static func XYZTo\(name.rawValue)(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> \(name.rawValue) {
                XYZToRGB(color: color, illuminant: illuminant, infos: infos)
            }
            """
        }
        
        let rgbs: [ColorSpaceType.RGB] = [
            .BT709RGB, .DCIP3RGB, .DCIP3PRGB, .DisplayP3RGB, .CIERGB, .AdobeWideGamutRGB
        ]
        
        print("--- xyz2rgbFunc ---")
        rgbs.forEach({
            print(xyz2rgbFunc(name: $0)) ; print()
        })
        
        print("--- xyz2rgbProperty ---")
        rgbs.forEach({
            print(xyz2rgbProperty(name: $0)) ; print()
        })
        
    }
    
    func testHex2rgbFuncGen() throws {
        
        func colorProperty2(name: ColorSpaceType.RGB) -> String {
            """
            public static let HexTo\(name.rawValue): PathConverter = .init( .Hex ==> .\(name.rawValue)) {
                let color = $0.base as! Hex
                var infos = $1
                let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
                infos?["\(Illuminant.self)"] = nil
                return .init(
                    Self.HexTo\(name.rawValue)(color: color, illuminant: illuminant, infos: infos)
                )
            }
            """
        }
        
        func colorFunc2(name: ColorSpaceType.RGB) -> String {
            """
            public static func HexTo\(name.rawValue)(color: Hex, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> \(name.rawValue) {
                HexToRGB(color: color, illuminant: illuminant, infos: infos)
            }
            """
        }
        
        func colorProperty4(name: ColorSpaceType.RGB) -> String {
            """
            public static let \(name.rawValue)ToHex: PathConverter = .init( .\(name.rawValue) ==> .Hex) {
                let color = $0.base as! \(name.rawValue)
                var infos = $1
                let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
                infos?["\(Illuminant.self)"] = nil
                return .init(
                    Self.\(name.rawValue)ToHex(color: color, illuminant: illuminant, infos: infos)
                )
            }
            """
        }
        
        func colorFunc4(name: ColorSpaceType.RGB) -> String {
            """
            public static func \(name.rawValue)ToHex(color: \(name.rawValue), illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> Hex {
                RGBToHex(color: color, illuminant: illuminant, infos: infos)
            }
            """
        }
        
        let rgbs: [ColorSpaceType.RGB] = [
            .BT709RGB, .DCIP3RGB, .DCIP3PRGB, .DisplayP3RGB, .CIERGB, .AdobeWideGamutRGB
        ]
        
        print("--- colorFunc2 ---")
        rgbs.forEach({
            print(colorFunc2(name: $0)) ; print()
        })
        
        print("--- colorProperty2 ---")
        rgbs.forEach({
            print(colorProperty2(name: $0)) ; print()
        })
        
        print("--- colorFunc4 ---")
        rgbs.forEach({
            print(colorFunc4(name: $0)) ; print()
        })
        
        print("--- colorProperty4 ---")
        rgbs.forEach({
            print(colorProperty4(name: $0)) ; print()
        })
        
    }

    func testRgb2xyzFuncGen() throws {
        
        func colorProperty2(name: ColorSpaceType.RGB, _ to: String) -> String {
            """
            public static let \(name.rawValue)To\(to): PathConverter = .init( .\(name.rawValue) ==> .\(to) ) {
                let color = $0.base as! \(name.rawValue)
                var infos = $1
                let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
                infos?["\(Illuminant.self)"] = nil
                return .init(
                    Self.\(name.rawValue)To\(to)(color: color, illuminant: illuminant, infos: infos)
                )
            }
            """
        }
        
        func colorFunc2(name: ColorSpaceType.RGB, _ to: String) -> String {
            """
            public static func \(name.rawValue)To\(to)(color: \(name.rawValue), illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> \(to) {
                RGBTo\(to)(color: color, illuminant: illuminant, infos: infos)
            }
            """
        }
        
        let rgbs: [ColorSpaceType.RGB] = [
            .BT709RGB, .DCIP3RGB, .DCIP3PRGB, .DisplayP3RGB, .CIERGB, .AdobeWideGamutRGB
        ]
        
        print("--- colorFunc2 xyz ---")
        rgbs.forEach({
            print(colorFunc2(name: $0, "\(XYZ.self)")) ; print()
        })
        
        print("--- colorProperty2 xyz ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, "\(XYZ.self)")) ; print()
        })
        
    }
    
    func testRgb2hsv2hsl2cmyFuncGen() throws {
        
        func colorProperty2(name: ColorSpaceType.RGB, _ to: String) -> String {
            """
            public static let \(name.rawValue)To\(to): PathConverter = .init( .\(name.rawValue) ==> .\(to) ) {
                .init( Self.\(name.rawValue)To\(to)(color: ($0.base as! \(name.rawValue)), infos: $1) )
            }
            """
        }
        
        func colorFunc2(name: ColorSpaceType.RGB, _ to: String) -> String {
            """
            public static func \(name.rawValue)To\(to)(color: \(name.rawValue), infos: [AnyHashable: Any]?) -> \(to) {
                RGBTo\(to)(color: color, infos: infos)
            }
            """
        }
        
        let rgbs: [ColorSpaceType.RGB] = [
            .BT709RGB, .DCIP3RGB, .DCIP3PRGB, .DisplayP3RGB, .CIERGB, .AdobeWideGamutRGB
        ]
        
        print("--- colorFunc2 hsv ---")
        rgbs.forEach({
            print(colorFunc2(name: $0, "\(HSV.self)")) ; print()
        })
        
        print("--- colorProperty2 hsv ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, "\(HSV.self)")) ; print()
        })
        
        print("--- colorFunc2 hsl ---")
        rgbs.forEach({
            print(colorFunc2(name: $0, "\(HSL.self)")) ; print()
        })
        
        print("--- colorProperty2 hsl ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, "\(HSL.self)")) ; print()
        })
        
        print("--- colorFunc2 cmy ---")
        rgbs.forEach({
            print(colorFunc2(name: $0, "\(CMY.self)")) ; print()
        })
        
        print("--- colorProperty2 cmy ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, "\(CMY.self)")) ; print()
        })
        
    }
    
    func testHsvHslCmy2rgbFuncGen() throws {
        
        func colorProperty2(name: ColorSpaceType.RGB, _ to: String) -> String {
            """
            public static let \(to)To\(name.rawValue): PathConverter = .init( .\(to) ==> .\(name.rawValue) ) {
                .init( Self.\(to)To\(name.rawValue)(color: ($0.base as! \(to)), infos: $1) )
            }
            """
        }
        
        func colorFunc2(name: ColorSpaceType.RGB, _ to: String) -> String {
            """
            public static func \(to)To\(name.rawValue)(color: \(to), infos: [AnyHashable: Any]?) -> \(name.rawValue) {
                \(to)ToRGB(color: color, infos: infos)
            }
            """
        }
        
        let rgbs: [ColorSpaceType.RGB] = [
            .BT709RGB, .DCIP3RGB, .DCIP3PRGB, .DisplayP3RGB, .CIERGB, .AdobeWideGamutRGB
        ]
        
        print("--- colorFunc2 hsv ---")
        rgbs.forEach({
            print(colorFunc2(name: $0, "\(HSV.self)")) ; print()
        })
        
        print("--- colorProperty2 hsv ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, "\(HSV.self)")) ; print()
        })
        
        print("--- colorFunc2 hsl ---")
        rgbs.forEach({
            print(colorFunc2(name: $0, "\(HSL.self)")) ; print()
        })
        
        print("--- colorProperty2 hsl ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, "\(HSL.self)")) ; print()
        })
        
        print("--- colorFunc2 cmy ---")
        rgbs.forEach({
            print(colorFunc2(name: $0, "\(CMY.self)")) ; print()
        })
        
        print("--- colorProperty2 cmy ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, "\(CMY.self)")) ; print()
        })
        
    }
    
    func testRgb2xxxPathGen() throws {
        
        func colorProperty2(name: ColorSpaceType.RGB, pass: String, _ to: String) -> String {
            """
            public static let \(name.rawValue)_2_\(to): RgbSelectorTuple = (
                .\(name.rawValue) ==> .\(to), [ \(name.rawValue)To\(pass), \(pass)To\(to) ]
            )
            """
        }
        
        func colorProperty22(name: ColorSpaceType.RGB, pass1: String, pass2: String, _ to: String) -> String {
            """
            public static let \(name.rawValue)_2_\(to): RgbSelectorTuple = (
                .\(name.rawValue) ==> .\(to), [ \(name.rawValue)To\(pass1), \(pass1)To\(pass2), \(pass2)To\(to) ]
            )
            """
        }
        
        let rgbs: [ColorSpaceType.RGB] = [
            .BT709RGB, .DCIP3RGB, .DCIP3PRGB, .DisplayP3RGB, .CIERGB, .AdobeWideGamutRGB
        ]
        
        print("--- colorProperty2 cmyk ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, pass: "\(CMY.self)", "\(CMYK.self)")) ; print()
        })
        
        print("--- colorProperty2 xyY ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, pass: "\(XYZ.self)", "\(xyY.self)")) ; print()
        })
        
        print("--- colorProperty2 lab ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, pass: "\(XYZ.self)", "\(Lab.self)")) ; print()
        })
        
        print("--- colorProperty2 lab ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, pass: "\(XYZ.self)", "\(Lab.self)")) ; print()
        })
        
        print("--- colorProperty2 lchlab ---")
        rgbs.forEach({
            print(colorProperty22(name: $0, pass1: "\(XYZ.self)", pass2: "\(Lab.self)", "\(LCHab.self)")) ; print()
        })
        
        print("--- colorProperty2 luv ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, pass: "\(XYZ.self)", "\(Luv.self)")) ; print()
        })
        
        print("--- colorProperty2 lchuv ---")
        rgbs.forEach({
            print(colorProperty22(name: $0, pass1: "\(XYZ.self)", pass2: "\(Luv.self)", "\(LCHuv.self)")) ; print()
        })
        
        print("--- colorProperty2 ipt ---")
        rgbs.forEach({
            print(colorProperty2(name: $0, pass: "\(XYZ.self)", "\(IPT.self)")) ; print()
        })
        
    }
    
    func testSelectorGen() throws {
        
        func colorProperty2(from: String, to: String) -> String {
            """
            \(from)To\(to).pathId:  \(from)To\(to),
            """
        }
        
        let rgbs: [ColorSpaceType.RGB] = [
            .BT709RGB, .DCIP3RGB, .DCIP3PRGB, .DisplayP3RGB, .CIERGB, .AdobeWideGamutRGB
        ]
        
        print("--- colorProperty2 xyz2rgb ---")
        rgbs.forEach({
            print(colorProperty2(from: "\(XYZ.self)", to: $0.rawValue))
        })
        
        print("--- colorProperty2 hex2rgb ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: "\(Hex.self)", to: $0.rawValue))
        })
        
        print("--- colorProperty2 rgb2hex ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: $0.rawValue, to: "\(Hex.self)"))
        })
        
        print("--- colorProperty2 rgb2xyz ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: $0.rawValue, to: "\(XYZ.self)"))
        })
        
        print("--- colorProperty2 rgb2hsv ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: $0.rawValue, to: "\(HSV.self)"))
        })
        
        print("--- colorProperty2 rgb2hsl ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: $0.rawValue, to: "\(HSL.self)"))
        })
        
        print("--- colorProperty2 rgb2cmy ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: $0.rawValue, to: "\(CMY.self)"))
        })
        
        print("--- colorProperty2 hsv2rgb ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: "\(HSV.self)", to: $0.rawValue))
        })
        
        print("--- colorProperty2 hsl2rgb ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: "\(HSL.self)", to: $0.rawValue))
        })
        
        print("--- colorProperty2 cmy2rgb ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: "\(CMY.self)", to: $0.rawValue))
        })
        
    }
    
    
    func testSelectorEdgeGen() throws {
        
        func colorProperty2(from: String, to: String) -> String {
            """
            addEdge(byFrom: .\(from), to: .\(to))
            """
        }
        
        let rgbs: [ColorSpaceType.RGB] = [
            .BT709RGB, .DCIP3RGB, .DCIP3PRGB, .DisplayP3RGB, .CIERGB, .AdobeWideGamutRGB
        ]
        
        print("--- colorProperty2 xyz2rgb ---")
        rgbs.forEach({
            print(colorProperty2(from: "\(XYZ.self)", to: $0.rawValue))
        })
        
        print("--- colorProperty2 hex2rgb ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: "\(Hex.self)", to: $0.rawValue))
        })
        
        print("--- colorProperty2 rgb2hex ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: $0.rawValue, to: "\(Hex.self)"))
        })
        
        print("--- colorProperty2 rgb2xyz ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: $0.rawValue, to: "\(XYZ.self)"))
        })
        
        print("--- colorProperty2 rgb2hsv ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: $0.rawValue, to: "\(HSV.self)"))
        })
        
        print("--- colorProperty2 rgb2hsl ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: $0.rawValue, to: "\(HSL.self)"))
        })
        
        print("--- colorProperty2 rgb2cmy ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: $0.rawValue, to: "\(CMY.self)"))
        })
        
        print("--- colorProperty2 hsv2rgb ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: "\(HSV.self)", to: $0.rawValue))
        })
        
        print("--- colorProperty2 hsl2rgb ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: "\(HSL.self)", to: $0.rawValue))
        })
        
        print("--- colorProperty2 cmy2rgb ---") ; print()
        rgbs.forEach({
            print(colorProperty2(from: "\(CMY.self)", to: $0.rawValue))
        })
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {

        }
    }

}
