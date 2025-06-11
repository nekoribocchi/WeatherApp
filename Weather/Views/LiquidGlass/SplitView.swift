//
//  SplitView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/11.
//

import SwiftUI

struct Employee: Identifiable, Hashable {
    let id: UUID
    let name: String
}

struct SplitView: View {
    @State private var employees: [Employee] = [
        Employee(id: UUID(), name: "Alice"),
        Employee(id: UUID(), name: "Bob"),
        Employee(id: UUID(), name: "Charlie")
    ]
    @State private var employeeIds: Set<UUID> = []
    
    var body: some View {
        NavigationSplitView {
            List(employees, selection: $employeeIds) { employee in
                Text(employee.name)
            }
        } detail: {
            if let selectedId = employeeIds.first, let selected = employees.first(where: { $0.id == selectedId }) {
                Text("Selected: \(selected.name)")
            } else {
                Text("Select an employee")
            }
        }
    }
}

#Preview {
    SplitView()
}
