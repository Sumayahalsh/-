import SwiftUI

// تعريف Plant
struct Plant: Identifiable, Codable {
    var id: UUID
    let name: String
    let room: String
    let light: String
    let waterAmount: String
    var isWatered: Bool = false
}

struct PlantDetailsView: View {
    @Binding var plants: [Plant]
    @State private var isSheetPresented = false

    private let plantsKey = "savedPlants"

    var allPlantsWatered: Bool {
        plants.allSatisfy { $0.isWatered }
    }

    var body: some View {
        NavigationStack {
            if allPlantsWatered {
                AllDoneView {
                    isSheetPresented = true  // فتح ورقة إضافة تذكير جديد عند النقر على الزر
                }
            } else {
                content
            }
        }
        .onAppear {
            loadPlants()
        }
        .sheet(isPresented: $isSheetPresented) {
            NewReminderSheet { newPlant in
                let plant = Plant(id: UUID(), name: newPlant.name, room: newPlant.room, light: newPlant.light, waterAmount: newPlant.waterAmount, isWatered: newPlant.isWatered)
                plants.append(plant)
                savePlants()
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
                                    .font(.subheadline)
                            }
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            HStack {
                                Image(systemName: "drop.fill")
                                    .foregroundColor(.teal)
                                Text(plant.waterAmount)
                                    .font(.subheadline)
                            }
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.vertical, 5)
                }
                .onDelete(perform: deletePlant)
            }
            .listStyle(PlainListStyle())
            
            Spacer()
            
            Button(action: {
                isSheetPresented = true
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

struct AllDoneView: View {
    var onNewReminder: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Spacer() // لإبقاء المحتوى في المنتصف
            
            Image("plant2") // تأكد من إضافة الصورة إلى الأصول
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240, height: 240)
                .padding(.bottom, -20)
                .padding(.leading, -30)

            Text("All Done! 🎉")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("All Reminders Completed")
                .foregroundColor(.gray)
            
            Spacer() // لإبقاء المحتوى في المنتصف
            
            Button(action: onNewReminder) {
                HStack {
                    
                    Image(systemName: "plus.circle.fill")
                        .padding(.leading, -170)
                    Text("New Reminder")
                        .padding(.leading, -150)
                }
                .font(.headline)
                .foregroundColor(.green)
                .padding()
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}

struct NewRemindeسrSheet: View {
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

struct PicسerSection: View {
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
