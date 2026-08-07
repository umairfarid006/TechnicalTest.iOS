//
//  AbsenceRowView.swift
//  BrightAbsences
//
//  Created by Umair on 07/08/2026.
//

import SwiftUI

struct AbsenceRowView: View {
    let absence: Absence
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(absence.employee.fullName)
                .bold()
            Text(absence.absenceType)
            Text("\(absence.days) days")
        }
    }
}

#Preview {
    AbsenceRowView(absence: .mock)
}
