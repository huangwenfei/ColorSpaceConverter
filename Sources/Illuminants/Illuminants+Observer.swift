//
//  Illuminants+Observer.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/9.
//

import Foundation

extension Illuminant {
    
    public enum TwoObserver: Int {
        /// CIE
        case A, B, C,
             D50, D55, D60, D65, D75,
             E,
             FL1, FL2, FL3, FL4, FL5, FL6, FL7, FL8, FL9, FL10, FL11, FL12,
             FL3_1, FL3_2, FL3_3, FL3_4, FL3_5, FL3_6, FL3_7, FL3_8, FL3_9,
             FL3_10, FL3_11, FL3_12, FL3_13, FL3_14, FL3_15,
             HP1, HP2, HP3, HP4, HP5,
             LED_B1, LED_B2, LED_B3, LED_B4, LED_B5, LED_BH1, LED_RGB1,
             LED_V1, LED_V2, ID65, ID50
        
        public var xy: [ColorElement.Element] {
            switch self {
            case .A:        return [0.44758, 0.40745]
            case .B:        return [0.34842, 0.35161]
            case .C:        return [0.31006, 0.31616]
            case .D50:      return [0.34570, 0.35850]
            case .D55:      return [0.33243, 0.34744]
            case .D60:      return [0.321616709705268, 0.337619916550817]
            case .D65:      return [0.31270, 0.32900]
            case .D75:      return [0.29903, 0.31488]
            case .E:        return [1.0 / 3.0, 1.0 / 3.0]
            case .FL1:      return [0.31310, 0.33710]
            case .FL2:      return [0.37210, 0.37510]
            case .FL3:      return [0.40910, 0.39410]
            case .FL4:      return [0.44020, 0.40310]
            case .FL5:      return [0.31380, 0.34520]
            case .FL6:      return [0.37790, 0.38820]
            case .FL7:      return [0.31290, 0.32920]
            case .FL8:      return [0.34580, 0.35860]
            case .FL9:      return [0.37410, 0.37270]
            case .FL10:     return [0.34580, 0.35880]
            case .FL11:     return [0.38050, 0.37690]
            case .FL12:     return [0.43700, 0.40420]
            case .FL3_1:    return [0.44070, 0.40330]
            case .FL3_2:    return [0.38080, 0.37340]
            case .FL3_3:    return [0.31530, 0.34390]
            case .FL3_4:    return [0.44290, 0.40430]
            case .FL3_5:    return [0.37490, 0.36720]
            case .FL3_6:    return [0.34880, 0.36000]
            case .FL3_7:    return [0.43840, 0.40450]
            case .FL3_8:    return [0.38200, 0.38320]
            case .FL3_9:    return [0.34990, 0.35910]
            case .FL3_10:   return [0.34550, 0.35600]
            case .FL3_11:   return [0.32450, 0.34340]
            case .FL3_12:   return [0.43770, 0.40370]
            case .FL3_13:   return [0.38300, 0.37240]
            case .FL3_14:   return [0.34470, 0.36090]
            case .FL3_15:   return [0.31270, 0.32880]
            case .HP1:      return [0.53300, 0.4150]
            case .HP2:      return [0.47780, 0.41580]
            case .HP3:      return [0.43020, 0.40750]
            case .HP4:      return [0.38120, 0.37970]
            case .HP5:      return [0.37760, 0.37130]
            case .LED_B1:   return [0.45600, 0.40780]
            case .LED_B2:   return [0.43570, 0.40120]
            case .LED_B3:   return [0.37560, 0.37230]
            case .LED_B4:   return [0.34220, 0.35020]
            case .LED_B5:   return [0.31180, 0.32360]
            case .LED_BH1:  return [0.44740, 0.40660]
            case .LED_RGB1: return [0.45570, 0.42110]
            case .LED_V1:   return [0.45480, 0.40440]
            case .LED_V2:   return [0.37810, 0.37750]
            case .ID65:     return [0.310656625403120, 0.330663091836953]
            case .ID50:     return [0.343211370103531, 0.360207541805137]
            }
        }
        
    }
    
    
    public enum TenObserver: Int {
        // CIE
        case A, B, C,
             D50, D55, D60, D65, D75,
             E,
             FL1, FL2, FL3, FL4, FL5, FL6, FL7, FL8, FL9, FL10, FL11, FL12,
             FL3_1, FL3_2, FL3_3, FL3_4, FL3_5, FL3_6, FL3_7, FL3_8, FL3_9,
             FL3_10, FL3_11, FL3_12, FL3_13, FL3_14, FL3_15,
             HP1, HP2, HP3, HP4, HP5,
             LED_B1, LED_B2, LED_B3, LED_B4, LED_B5, LED_BH1, LED_RGB1,
             LED_V1, LED_V2, ID65, ID50
                         
        public var xy: [ColorElement.Element] {
            switch self {
            case .A:        return [0.45117, 0.40594]
            case .B:        return [0.34980, 0.35270]
            case .C:        return [0.31039, 0.31905]
            case .D50:      return [0.34773, 0.35952]
            case .D55:      return [0.33412, 0.34877]
            case .D60:      return [0.322986926715820, 0.339275732345997]
            case .D65:      return [0.31382, 0.33100]
            case .D75:      return [0.29968, 0.31740]
            case .E:        return [1.0 / 3.0, 1.0 / 3.0]
            case .FL1:      return [0.31811, 0.33559]
            case .FL2:      return [0.37925, 0.36733]
            case .FL3:      return [0.41761, 0.38324]
            case .FL4:      return [0.44920, 0.39074]
            case .FL5:      return [0.31975, 0.34246]
            case .FL6:      return [0.38660, 0.37847]
            case .FL7:      return [0.31569, 0.32960]
            case .FL8:      return [0.34902, 0.35939]
            case .FL9:      return [0.37829, 0.37045]
            case .FL10:     return [0.35090, 0.35444]
            case .FL11:     return [0.38541, 0.37123]
            case .FL12:     return [0.44256, 0.39717]
            case .FL3_1:    return [0.449830684010003, 0.390231404321266]
            case .FL3_2:    return [0.386924116672933, 0.365756034732821]
            case .FL3_3:    return [0.321176986855865, 0.340501092654981]
            case .FL3_4:    return [0.448121275113995, 0.397077112142482]
            case .FL3_5:    return [0.377814166608895, 0.366625766963060]
            case .FL3_6:    return [0.351976478983504, 0.361094432889677]
            case .FL3_7:    return [0.444309208810922, 0.396791387314871]
            case .FL3_8:    return [0.387588931999771, 0.376305569410173]
            case .FL3_9:    return [0.354688990710449, 0.353445033593383]
            case .FL3_10:   return [0.349344792334400, 0.354984421140869]
            case .FL3_11:   return [0.329267975695120, 0.338865386643537]
            case .FL3_12:   return [0.442252080438001, 0.401220551071252]
            case .FL3_13:   return [0.386275268780817, 0.374283190950586]
            case .FL3_14:   return [0.347255078638291, 0.366808242504180]
            case .FL3_15:   return [0.314613997909246, 0.333377149377113]
            case .HP1:      return [0.543334600247307, 0.405289298480431]
            case .HP2:      return [0.482647330648721, 0.410815644179685]
            case .HP3:      return [0.435560034503954, 0.398801084399711]
            case .HP4:      return [0.385193641123543, 0.368275479241015]
            case .HP5:      return [0.380316415606638, 0.366617114797851]
            case .LED_B1:   return [0.462504966271043, 0.403041801546906]
            case .LED_B2:   return [0.442119475258745, 0.396633702892576]
            case .LED_B3:   return [0.380851979328052, 0.368518548904765]
            case .LED_B4:   return [0.348371362473402, 0.345065503264192]
            case .LED_B5:   return [0.316916877024753, 0.322060276350364]
            case .LED_BH1:  return [0.452772610754910, 0.400032462750000]
            case .LED_RGB1: return [0.457036370583652, 0.425381348780888]
            case .LED_V1:   return [0.453602699414564, 0.398199587905174]
            case .LED_V2:   return [0.377728483834020, 0.374512315539769]
            case .ID65:     return [0.312074043269908, 0.332660121024630]
            case .ID50:     return [0.345621427535976, 0.361228962209198]
            }
        }
    }
    
}
