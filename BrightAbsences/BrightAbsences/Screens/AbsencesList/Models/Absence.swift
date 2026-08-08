//
//  Absense.swift
//  BrightAbsences
//
//  Created by Umair on 06/08/2026.
//

struct Absence: Decodable{
    let id : Int
    let startDate: String
    let days: Int
    let absenceType: AbsenceType
    let approved: Bool
    let employee: Employee
    var hasConflict: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case startDate
        case days
        case absenceType
        case approved
        case employee
    }
}

struct Employee: Decodable{
    let firstName : String
    let lastName: String
    let id: String
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

enum AbsenceType: String, Decodable {
    case annualLeave = "ANNUAL_LEAVE"
    case sickness = "SICKNESS"
    case medical = "MEDICAL"

    var title: String {
        switch self {
        case .annualLeave:
            return "Annual Leave"
        case .sickness:
            return "Sickness"
        case .medical:
            return "Medical"
        }
    }
}

extension Absence {
    static var mock: Absence {
        Absence(
            id: 1,
            startDate: "2026-08-07",
            days: 3,
            absenceType: .annualLeave,
            approved: true,
            employee: .mock
        )
    }
    
    static var mockWithConflict: Absence {
        Absence(
            id: 2,
            startDate: "2026-08-07",
            days: 3,
            absenceType: .annualLeave,
            approved: true,
            employee: .mock,
            hasConflict: true
        )
    }
}

extension Employee {
    static var mock: Employee {
        Employee(
            firstName: "Umair",
            lastName: "Farid",
            id: "1"
        )
    }
}
