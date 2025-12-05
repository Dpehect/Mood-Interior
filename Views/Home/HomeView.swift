import SwiftUI
import PhotosUI

struct HomeView: View {
    @ObservedObject var viewModel: DesignViewModel
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedStyle = "Modern"
    @State private var showGeneratedImage = false
    @State private var showIdeaPopup = false
    @State private var currentIdea = ""
    @State private var showAddStyleAlert = false
    @State private var newStyleName = ""
    @State private var styles = ["Modern", "Cyberpunk", "Candy", "Space", "Jungle", "Lego", "Minecraft", "Barbie"]
    
    let creativeIdeas = [
        "🍬 Turn your room into a candy castle!",
        "🚀 Make it look like a Mars base!",
        "🦖 A wild jungle theme with dinosaurs!",
        "🧱 A colorful room made entirely of LEGO bricks!",
        "🌈 A room with neon lights in rainbow colors!",
        "🏰 Like a medieval castle with stone walls!",
        "🌊 An underwater city with aquarium walls!"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                ZStack {
                    Color(.systemBackground).ignoresSafeArea()
                    
                    Circle().fill(Color.purple.opacity(0.2)).frame(width: 300).offset(x: -150, y: -300).blur(radius: 60)
                    Circle().fill(Color.blue.opacity(0.2)).frame(width: 300).offset(x: 150, y: 100).blur(radius: 60)
                    Circle().fill(Color.pink.opacity(0.2)).frame(width: 200).offset(x: -100, y: 300).blur(radius: 50)
                }
                
                ScrollView {
                    VStack(spacing: 25) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Dream Room")
                                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                                    .foregroundStyle(LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing))
                                Text("Transform your space! ✨")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            Button(action: { generateRandomIdea() }) {
                                Image(systemName: "lightbulb.max.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.yellow)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(Circle())
                                    .shadow(color: .yellow.opacity(0.4), radius: 10, x: 0, y: 5)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        ZStack {
                            if let imageToShow = currentDisplayImage {
                                Image(uiImage: imageToShow)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 350)
                                    .clipShape(RoundedRectangle(cornerRadius: 35))
                                    .shadow(color: .purple.opacity(0.2), radius: 20, x: 0, y: 10)
                                    .overlay(alignment: .bottomTrailing) {
                                        if viewModel.generatedImage != nil {
                                            Button(action: {
                                                withAnimation(.bouncy) { showGeneratedImage.toggle() }
                                            }) {
                                                Text(showGeneratedImage ? "Original ↺" : "See Magic ✨")
                                                    .font(.system(.caption, design: .rounded).bold())
                                                    .padding(12)
                                                    .background(.thinMaterial)
                                                    .clipShape(Capsule())
                                                    .padding()
                                            }
                                        }
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 35)
                                    .fill(Color(.secondarySystemBackground))
                                    .frame(height: 350)
                                    .shadow(color: .black.opacity(0.05), radius: 10)
                                    .overlay(
                                        VStack(spacing: 15) {
                                            Image(systemName: "camera.macro.circle.fill")
                                                .font(.system(size: 60))
                                                .foregroundStyle(LinearGradient(colors: [.pink, .purple], startPoint: .top, endPoint: .bottom))
                                            Text("Add a photo here!")
                                                .font(.system(.title3, design: .rounded).bold())
                                                .foregroundColor(.secondary)
                                        }
                                    )
                            }
                            
                            if viewModel.isProcessing {
                                ZStack {
                                    Color.black.opacity(0.6).cornerRadius(35)
                                    VStack {
                                        ProgressView()
                                            .tint(.white)
                                            .scaleEffect(1.5)
                                        Text("Magic is happening...")
                                            .font(.system(.headline, design: .rounded))
                                            .foregroundColor(.white)
                                            .padding(.top, 10)
                                    }
                                }
                                .frame(height: 350)
                            }
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Which Style?")
                                    .font(.system(.title3, design: .rounded).bold())
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(styles, id: \.self) { style in
                                        Button(action: {
                                            withAnimation(.spring()) { selectedStyle = style }
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        }) {
                                            VStack {
                                                Text(emojiForStyle(style))
                                                    .font(.largeTitle)
                                                Text(style)
                                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.8)
                                            }
                                            .frame(width: 100, height: 110)
                                            .background(selectedStyle == style ? Color.purple : Color(.secondarySystemBackground))
                                            .foregroundColor(selectedStyle == style ? .white : .primary)
                                            .cornerRadius(25)
                                            .shadow(color: selectedStyle == style ? .purple.opacity(0.4) : .black.opacity(0.05), radius: 8, x: 0, y: 4)
                                            .scaleEffect(selectedStyle == style ? 1.05 : 1.0)
                                        }
                                    }
                                    
                                    Button(action: {
                                        newStyleName = ""
                                        showAddStyleAlert = true
                                    }) {
                                        VStack {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.largeTitle)
                                                .foregroundStyle(LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom))
                                            Text("New")
                                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                                .foregroundColor(.secondary)
                                        }
                                        .frame(width: 100, height: 110)
                                        .background(Color(.secondarySystemBackground))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                                .foregroundColor(.gray.opacity(0.5))
                                        )
                                        .cornerRadius(25)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                            }
                        }
                        
                        HStack(spacing: 15) {
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                HStack {
                                    Image(systemName: "photo.fill")
                                    Text("Photo")
                                }
                                .font(.system(.headline, design: .rounded))
                                .frame(height: 60)
                                .frame(maxWidth: .infinity)
                                .background(Color(.secondarySystemBackground))
                                .foregroundColor(.primary)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.05), radius: 5)
                            }
                            
                            Button(action: {
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                viewModel.generateDesign(style: selectedStyle)
                                showGeneratedImage = true
                            }) {
                                HStack {
                                    Text("Transform")
                                    Image(systemName: "wand.and.stars.inverse")
                                }
                                .font(.system(.headline, design: .rounded))
                                .frame(height: 60)
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(colors: [Color.purple, Color.pink], startPoint: .leading, endPoint: .trailing)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .shadow(color: .pink.opacity(0.4), radius: 10, x: 0, y: 5)
                            }
                            .disabled(viewModel.originalImage == nil || viewModel.isProcessing)
                            .opacity(viewModel.originalImage == nil ? 0.6 : 1)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .overlay {
                if showIdeaPopup {
                    ZStack {
                        Color.black.opacity(0.5).ignoresSafeArea()
                            .onTapGesture { withAnimation { showIdeaPopup = false } }
                        
                        VStack(spacing: 20) {
                            Image(systemName: "lightbulb.circle.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(.yellow, .orange)
                                .symbolEffect(.bounce, value: showIdeaPopup)
                            
                            Text("AI Suggests!")
                                .font(.system(.title2, design: .rounded).bold())
                                .foregroundColor(.black)
                            
                            Text(currentIdea)
                                .font(.system(.body, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            Button("Let's try it! 🚀") {
                                withAnimation { showIdeaPopup = false }
                            }
                            .font(.system(.headline, design: .rounded))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                        .padding(30)
                        .background(Color.white)
                        .cornerRadius(30)
                        .padding(40)
                    }
                }
            }
            .alert("Add New Style", isPresented: $showAddStyleAlert) {
                TextField("e.g. Steampunk", text: $newStyleName)
                Button("Add") {
                    if !newStyleName.isEmpty {
                        withAnimation {
                            styles.append(newStyleName)
                            selectedStyle = newStyleName
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        withAnimation {
                            viewModel.originalImage = uiImage
                            viewModel.generatedImage = nil
                            showGeneratedImage = false
                        }
                    }
                }
            }
        }
    }
    
    var currentDisplayImage: UIImage? {
        return showGeneratedImage ? viewModel.generatedImage : viewModel.originalImage
    }
    
    func generateRandomIdea() {
        currentIdea = creativeIdeas.randomElement() ?? "Design an awesome room!"
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            showIdeaPopup = true
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    func emojiForStyle(_ style: String) -> String {
        switch style {
        case "Modern": return "🛋️"
        case "Cyberpunk": return "😎"
        case "Candy": return "🍬"
        case "Space": return "🚀"
        case "Jungle": return "🌴"
        case "Lego": return "🧱"
        case "Minecraft": return "🟩"
        case "Barbie": return "💅"
        case "Steampunk": return "⚙️"
        case "Gothic": return "🦇"
        default: return "🎨"
        }
    }
}
