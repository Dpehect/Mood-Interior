import SwiftUI

struct GalleryView: View {
    @ObservedObject var viewModel: DesignViewModel
    @State private var selectedDesign: DesignResult?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                if viewModel.savedDesigns.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "photo.stack")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No Designs Yet")
                            .font(.title3.bold())
                            .foregroundColor(.gray)
                        Text("Create your first magic room!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.savedDesigns) { design in
                                Button(action: { selectedDesign = design }) {
                                    VStack {
                                        Image(uiImage: design.generatedImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 150)
                                            .clipped()
                                            .cornerRadius(15)
                                        HStack {
                                            Text(design.style).font(.caption.bold())
                                            Spacer()
                                            Text(design.date.formatted(date: .abbreviated, time: .omitted))
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.horizontal, 5)
                                        .foregroundColor(.primary)
                                    }
                                    .padding(10)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Gallery 🎨")
            .sheet(item: $selectedDesign) { design in
                DetailView(design: design)
            }
        }
    }
}

struct DetailView: View {
    let design: DesignResult
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Capsule().fill(Color.gray.opacity(0.3)).frame(width: 40, height: 6).padding(.top)
            Spacer()
            Image(uiImage: design.generatedImage)
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .padding()
                .shadow(radius: 10)
            
            Text("Style: \(design.style)")
                .font(.title2.bold())
            
            Spacer()
            
            ShareLink(item: Image(uiImage: design.generatedImage), preview: SharePreview("My Dream Room", image: Image(uiImage: design.generatedImage))) {
                Label("Share Design", systemImage: "square.and.arrow.up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .padding()
        }
    }
}
