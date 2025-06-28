import SwiftUI
import InjectPropertyWrapper
import FirebaseCrashlytics

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("settings.chooseLanguage".localized())
                    .font(Fonts.subheading)
                    .padding(.bottom, LayoutConst.maxPadding)
                HStack(spacing: 12) {
                    StyledButton(style: viewModel.selectedLanguage == "en" ? .filled : .outlined, action: .simple, title: "settings.lang.english".localized())
                        .font(Fonts.detailsTitle)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            viewModel.changeSelectedLanguge("en")
                        }
                    StyledButton(style: viewModel.selectedLanguage == "de" ? .filled : .outlined, action: .simple, title: "settings.lang.russian".localized())
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            viewModel.changeSelectedLanguge("ru")
                        }
                    StyledButton(style: viewModel.selectedLanguage == "hu" ? .filled : .outlined, action: .simple, title: "settings.lang.hungarian".localized())
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            viewModel.changeSelectedLanguge("hu")
                        }
                }
                .padding(.bottom, 43)
                
                Text("settings.chooseTheme".localized())
                    .font(Fonts.subheading)
                    .padding(.bottom, LayoutConst.maxPadding)
                HStack(spacing: 12) {
                    StyledButton(style: viewModel.selectedTheme == .light ? .filled : .outlined, action: .simple, title: "settings.theme.light")
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            viewModel.changeTheme(.light)
                        }
                    StyledButton(style: viewModel.selectedTheme == .dark ? .filled : .outlined, action: .simple, title: "settings.theme.dark")
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            viewModel.changeTheme(.dark)
                        }
                }
                .padding(.bottom, 43)
                
                Spacer()
                VStack(spacing: LayoutConst.smallPadding) {
                    Text("Version \(viewModel.appInfo)")
                    Text("Created by Anpnymous")
                }
                .font(Fonts.subheading)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 66)
                
                Button {
                    viewModel.nonEscapingMethond {
                        print("non escaping success")
                    }
                } label: {
                    Text("Non escaping")
                }
                
                Button {
                    viewModel.escapingMethond {
                        print("escaping success")
                    }
                } label: {
                    Text("Escaping")
                }

            }
            .padding(LayoutConst.maxPadding)
            .navigationTitle("settings.title".localized())
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    SettingsView()
} 
