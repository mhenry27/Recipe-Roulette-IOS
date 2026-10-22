//
// InfoView.swift
//
import SwiftUI

struct InfoView: View {
    private var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Recipe Roulette"
    }
    
    private var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
    
    private var build: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }
    
    private var copyrightText: String {
        Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String
        ?? "© 2025 Your Name"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            // App icon – replace "AppIcon" with your asset if you like,
            // or just use a system image for preview.
            Image("AppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .cornerRadius(24)
                .shadow(radius: 8)
                .padding(.bottom, 8)
            
            Text(appName)
                .font(.title.bold())
            
            Text("Version \(version) (\(build))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Recipe Roulette fetches random recipes from a public API and lets you save your favorites, customize filters, and get a daily ‘what’s for dinner?’ notification.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(copyrightText)
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            
            Spacer()
        }
        .padding()
        .background(Color("BackgroundColor").ignoresSafeArea())
    }
}

#Preview {
    InfoView()
}
