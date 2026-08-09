//
//  EmployeeAbsencesView.swift
//  BrightAbsences
//
//  Created by Umair on 09/08/2026.
//

import SwiftUI

struct EmployeeAbsencesView: View {
    let absences: [Absence]
    var body: some View {
        List(absences, id:\.id) { absence in
            AbsenceRowView(absence: absence)
        }
        .navigationTitle("Absences")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EmployeeAbsencesView(absences: [.mock, .mock])
}
