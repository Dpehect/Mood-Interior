import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = DesignViewModel()
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Design", systemImage: "wand.and.stars")
                }
            
            GalleryView(viewModel: viewModel)
                .tabItem {
                    Label("Gallery", systemImage: "photo.stack")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .accentColor(.purple)
    }
}
