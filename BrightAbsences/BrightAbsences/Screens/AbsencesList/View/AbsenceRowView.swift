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
            HStack {
                VStack(alignment: .leading) {
                    Text(absence.employee.fullName)
                        .bold()
                    Text(absence.absenceType)
                    Text("\(absence.days) days")
                }
                
                if absence.hasConflict {
                    Spacer()
                    VStack {
                        Text("Conflict")
                            .bold()
                            .foregroundColor(.red)
                            .padding()
                        
                    }
                    .background(Color.red.opacity(0.12))
                    .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    AbsenceRowView(absence: .mock)
}
