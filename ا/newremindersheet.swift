//
//  NewReminderSheet.swift
//  AppName
//
//  Created by Sumayah Alshehri on 24/04/1446 AH.
//

import SwiftUI

struct NewReminderSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var plantName: String = ""
    @State private var selectedRoom: String = "Bedroom"
    @State private var selectedLight: String = "Full Sun"
    @State private var selectedWaterAmount: String = "20-50 ml"
    
    let rooms = ["Bedroom", "Bathroom", "Kitchen", "Living Room", "Balcony"]
    let lights = ["Full Sun", "Partial Sun", "Low Sun"]
    let waterAmounts = ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"]
    
    var onSave: (Plant) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Plant Name", text: $plantName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                PickerSection(title: "Room", selection: $selectedRoom, options: rooms, icon: "location.fill")
                PickerSection(title: "Light", selection: $selectedLight, options: lights, icon: "sun.max.fill")
                PickerSection(title: "Water Amount", selection: $selectedWaterAmount, options: waterAmounts, icon: "drop.fill")
                
                Spacer()
            }
            .navigationTitle("Set Reminder")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newPlant = Plant(id: UUID(), name: plantName, room: selectedRoom, light: selectedLight, waterAmount: selectedWaterAmount)
                        onSave(newPlant)
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
            }
        }
    }
}

// تعريف PickerSection
struct PickerSection: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            Text(title)
                .font(.headline)
            Spacer()
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    NewReminderSheet { _ in }
}
