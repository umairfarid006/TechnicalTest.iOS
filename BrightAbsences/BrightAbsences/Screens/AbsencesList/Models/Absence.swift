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
    let absenceType: String
    let approved: Bool
    let employee: Employee
}

struct Employee: Decodable{
    let firstName : String
    let lastName: String
    let id: String
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

extension Absence {
    static var mock: Absence {
        Absence(
            id: 1,
            startDate: "2026-08-07",
            days: 3,
            absenceType: "Annual Leave",
            approved: true,
            employee: .mock
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
