//
//  AppErrors.swift
//  BrightAbsences
//
//  Created by Umair on 06/08/2026.
//

import Foundation

enum AppErrors: LocalizedError{
    case badUrl
    case invalidParams
    case invalidResponse
    case invalidData
    case unKnown
}

extension AppErrors{
    var description : String?{
        switch self{
        case .badUrl:
            return "Bad Url"
        case .invalidParams:
            return "invalidParams"
        case .invalidResponse:
            return "invalidResponse"
        case .invalidData:
            return "invalidData"
        case .unKnown:
            return "unKnown"
        }
    }
}
