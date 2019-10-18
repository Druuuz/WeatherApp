//
//  Extensions.swift
//  WeatherApp
//
//  Created by Андрей Олесов on 10/13/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import OAuthSwift
import CommonCrypto

enum Format:String{
    case ddMMyyyyHHmmSS = "dd-MM-yyyy hh-mm-ss"
    case ddMMyyyyHHmm = "dd/MM/yyyy hh:mm"
}
extension Date {
    func format(format:Format = .ddMMyyyyHHmmSS) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let dateString = dateFormatter.string(from: self)
        if let newDate = dateFormatter.date(from: dateString) {
            return newDate
        } else {
            return self
        }
    }
    
    func toString(withFormat format:Format = .ddMMyyyyHHmm)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
}


enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCEnum() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func digest(algorithm: HMACAlgorithm, key: String) -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = UInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength()
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = UInt(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.toCCEnum(), keyStr!, Int(keyLen), str!, Int(strLen), result)
        let data = NSData(bytesNoCopy: result, length: digestLen)
        result.deinitialize(count: digestLen)
        
        return data.base64EncodedString(options: [])
    }
}


