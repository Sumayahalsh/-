import SwiftUI

// Plant structure definition
struct Plant: Identifiable, Codable {
    var id: UUID
    var name: String
    var room: String
    var light: String
    var waterAmount: String
    var isWatered: Bool = false
}

struct PlantDetailsView: View {
    @Binding var plants: [Plant]
    @State private var isAddingNewPlant = false
    @State private var selectedPlant: Plant?

    private let plantsKey = "savedPlants"

    var allPlantsWatered: Bool {
        plants.allSatisfy { $0.isWatered }
    }

    var body: some View {
        NavigationStack {
            if allPlantsWatered {
                AllDoneView(onNewReminder: {
                    isAddingNewPlant = true
                })
            } else {
                content
            }
        }
        .onAppear {
            loadPlants()
        }
        .sheet(isPresented: $isAddingNewPlant) {
            EditPlantSheet(plant: Plant(id: UUID(), name: "", room: "Bedroom", light: "Full Sun", waterAmount: "20-50 ml")) { newPlant in
                plants.append(newPlant)
                savePlants()
            } onDelete: {}
        }
        .sheet(item: $selectedPlant) { plant in
            EditPlantSheet(plant: plant) { updatedPlant in
                if let index = plants.firstIndex(where: { $0.id == updatedPlant.id }) {
                    plants[index] = updatedPlant
                    savePlants()
                }
            } onDelete: {
                if let index = plants.firstIndex(where: { $0.id == plant.id }) {
                    plants.remove(at: index)
                    savePlants()
                }
            }
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            Text("My Plants 🌱")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Divider()
                .padding(.vertical, 10)
            
            Text("Today")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            List {
                ForEach($plants) { $plant in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.gray)
                            Text("in \(plant.room)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 10)
                        
                        HStack(alignment: .center, spacing: 8) {
                            Button(action: {
                                plant.isWatered.toggle()
                                savePlants()
                            }) {
                                Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(plant.isWatered ? .green : .gray)
                                    .font(.title2)
                            }
                            .padding(.leading, -18)
                            
                            Text(plant.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.leading, 4)
                        }
                        
                        HStack(spacing: 8) {
                            HStack {
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(.yellow)
                                Text(plant.light)
                                    .foregroundColor(.yellow)
                                    .font(.subheadline)
                            }
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            HStack {
                                Image(systemName: "drop.fill")
                                    .foregroundColor(.blue)
                                Text(plant.waterAmount)
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                            }
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.vertical, 5)
                    .onTapGesture {
                        selectedPlant = plant
                    }
                }
                .onDelete(perform: deletePlant)
            }
            .listStyle(PlainListStyle())
            
            Spacer()
            
            Button(action: {
                isAddingNewPlant = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Reminder")
                }
                .font(.headline)
                .foregroundColor(.green)
                .padding()
            }
        }
        .padding(.horizontal)
    }
    
    func savePlants() {
        if let encoded = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(encoded, forKey: plantsKey)
        }
    }
    
    func loadPlants() {
        if let savedData = UserDefaults.standard.data(forKey: plantsKey),
           let decoded = try? JSONDecoder().decode([Plant].self, from: savedData) {
            plants = decoded
        }
    }
    
    func deletePlant(at offsets: IndexSet) {
        plants.remove(atOffsets: offsets)
        savePlants()
    }
}

// AllDoneView definition
struct AllDoneView: View {
    var onNewReminder: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            
            Image("plant2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .foregroundColor(.green)
                .padding(.leading, -30)
            
            Text("All Done! 🎉")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("All Reminders Completed")
                .foregroundColor(.gray)
            
            Spacer()
            
            Button(action: onNewReminder) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Reminder")
                }
                .font(.headline)
                .foregroundColor(.green)
                .padding()
            }
        }
        .padding()
    }
}

// EditPlantSheet definition with custom inputs
struct EditPlantSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var plant: Plant

    var onSave: (Plant) -> Void
    var onDelete: () -> Void

    let rooms = ["Bedroom", "Bathroom", "Kitchen", "Living Room", "Balcony"]
    let lights = ["Full Sun", "Partial Sun", "Low Sun"]
    let waterAmounts = ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"]
    let wateringDays = ["Every Day", "Every 2 Days", "Every 3 Days", "Once a Week"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Text("Plant Name")
                        .foregroundColor(.white)
                        .font(.body)
                    TextField("", text: $plant.name)
                        .foregroundColor(.gray)
                        .font(.body)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)

                VStack(spacing: 0) {
                    PickerSection(title: "Room", selection: $plant.room, options: rooms, icon: "location.fill")
                        .padding(.leading, 8)
                    Divider()
                    PickerSection(title: "Light", selection: $plant.light, options: lights, icon: "sun.max.fill")
                        .padding(.leading, 8)
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                
                VStack(spacing: 0) {
                    PickerSection(title: "Water", selection: $plant.waterAmount, options: waterAmounts, icon: "drop.fill")
                        .padding(.leading, 8)
                    Divider()
                    PickerSection(title: "Watering Days", selection: .constant("Every 3 Days"), options: wateringDays, icon: "drop.fill")
                        .padding(.leading, 8)
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 16)

                Spacer()

                Button("Delete Plant", role: .destructive) {
                    onDelete()
                    dismiss()
                }
                .padding()
            }
            .navigationTitle("Edit Plant")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(plant)
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
            }
        }
    }
}

// Inline PickerSection View for Reusable Picker Components
struct PickerSdection: View {
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
    }
}
