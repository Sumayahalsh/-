//
//  NewReminderSheet.swift
//  AppName
//
//  Created by Sumayah Alshehri on 24/04/1446 AH.
//

import SwiftUI

struct NewReminderSheet: View {
    @Environment(\.dismiss) var dismiss
    
    // Default plant name
    @State private var plantName: String = "Pothos"
    
    @State private var selectedRoom: String = "Bedroom"
    @State private var selectedLight: String = "Full Sun"
    @State private var selectedWaterAmount: String = "20-50 ml"
    @State private var selectedWateringDays: String = "Every day" // Default watering frequency
    
    let rooms = ["Bedroom", "Bathroom", "Kitchen", "Living Room", "Balcony"]
    let lights = ["Full Sun", "Partial Sun", "Low Sun"]
    let waterAmounts = ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"]
    let wateringDays = ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"]
    
    var onSave: (Plant) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Custom TextField with static label "Plant Name"
                HStack {
                    Text("Plant Name")
                        .foregroundColor(.white)
                        .font(.body)
                    TextField("", text: $plantName) // Editable part for plant name
                        .foregroundColor(.gray)
                        .font(.body)
                        .textFieldStyle(PlainTextFieldStyle()) // Remove default border
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)

                // Combined Room and Light section in a single VStack container with reduced padding
                VStack(spacing: 0) {
                    PickerSection(title: "Room", selection: $selectedRoom, options: rooms, icon: "location.fill")
                        .padding(.leading, 8)
                    Divider()
                    PickerSection(title: "Light", selection: $selectedLight, options: lights, icon: "sun.max.fill")
                        .padding(.leading, 8)
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 16) // Reduced horizontal padding
                
                // Combined Water Amount and Watering Days section in a single VStack container with reduced padding
                VStack(spacing: 0) {
                    PickerSection(title: "Water", selection: $selectedWaterAmount, options: waterAmounts, icon: "drop.fill")
                        .padding(.leading, 8)
                    Divider()
                    PickerSection(title: "Watering Days", selection: $selectedWateringDays, options: wateringDays, icon: "drop.fill")
                        .padding(.leading, 8)
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 16) // Reduced horizontal padding

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.green1)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Set Reminder")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newPlant = Plant(id: UUID(), name: plantName, room: selectedRoom, light: selectedLight, waterAmount: selectedWaterAmount)
                        onSave(newPlant)
                        dismiss()
                    }
                    .foregroundColor(.green1)
                }
            }
        }
    }
}

// Definition of PickerSection with reduced padding
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
            .accentColor(.gray) // Change "green" to your preferred color
        }
        .padding(.vertical, 8) // Reduced vertical padding
    }
}

#Preview {
    NewReminderSheet { _ in }
}
