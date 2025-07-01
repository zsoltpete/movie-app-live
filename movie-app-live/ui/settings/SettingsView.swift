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
                        .onTapGesture {
                            viewModel.changeSelectedLanguge("en")
                        }
                    StyledButton(style: viewModel.selectedLanguage == "ru" ? .filled : .outlined, action: .simple, title: "settings.lang.russian".localized())
                        .font(Fonts.detailsButton)
                        .onTapGesture {
                            viewModel.changeSelectedLanguge("ru")
                        }
                    StyledButton(style: viewModel.selectedLanguage == "hu" ? .filled : .outlined, action: .simple, title: "settings.lang.hungarian".localized())
                        .font(Fonts.detailsButton)
                        .onTapGesture {
                            viewModel.changeSelectedLanguge("hu")
                        }
                }
                .padding(.bottom, 43)
                
                Text("settings.chooseTheme".localized())
                    .font(Fonts.subheading)
                    .padding(.bottom, LayoutConst.maxPadding)
                HStack(spacing: 12) {
                    StyledButton(style: viewModel.selectedTheme == .light ? .filled : .outlined, action: .simple, title: "settings.theme.light".localized())
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            viewModel.changeTheme(.light)
                        }
                    StyledButton(style: viewModel.selectedTheme == .dark ? .filled : .outlined, action: .simple, title: "settings.theme.dark".localized())
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
                    Text("version".localized() + ": \(viewModel.appInfo)")
                    Text("createdby".localized())
                }
                .font(Fonts.subheading)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 66)

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
