//
//  AppRoute.swift
//  BrightAbsences
//
//  Created by Umair on 09/08/2026.
//

import SwiftUI

enum AppRoute: Hashable {
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    case employeeAbsence([Absence])
}
