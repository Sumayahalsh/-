import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var plants: [Plant] = []  // مصفوفة تخزين النباتات
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                    .padding(.top, -80)
                
                Image("plant1") // تأكد من وجود الصورة في الأصول
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 280, height: 280, alignment: .center)
                    .padding(.bottom, -20)
                
                Text("Start your plant journey!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                Text("Now all your plants will be in one place and we will help you take care of them :) 🪴")
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                
                NavigationLink(destination: PlantDetailsView(plants: $plants)) {
                    Text("Set Plant Reminder")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green1)
                        .cornerRadius(20)
                        .padding(.horizontal, 30)
                }
            }
            .navigationTitle("My Plants 🌱")
        }
    }
}

#Preview {
    ContentView()
}
