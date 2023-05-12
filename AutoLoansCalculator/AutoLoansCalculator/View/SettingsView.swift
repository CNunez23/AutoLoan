import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCurrencySymbol: String
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Select Currency")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 40)
                    
                    HStack {
                        currencyButton(symbol: "$")
                        currencyButton(symbol: "€")
                    }
                    .padding(.top, 40)
                    
                    HStack {
                        currencyButton(symbol: "£")
                        currencyButton(symbol: "¥")
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(leading: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func currencyButton(symbol: String) -> some View {
        Button(action: {
            selectedCurrencySymbol = symbol
        }) {
            Text(symbol)
                .font(.system(size: 36))
                .foregroundColor(selectedCurrencySymbol == symbol ? .blue : .primary)
                .frame(width: 100, height: 100)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedCurrencySymbol == symbol ? Color.blue : Color.clear, lineWidth: 2)
                )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(selectedCurrencySymbol: .constant("$"))
    }
}
