import SwiftUI
import SwiftUICharts

struct ResultsView: View {
    let paymentDetails: PaymentDetails
    let graphData: [Double]
    @State private var showGraph = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Loan Details")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 40)
                
                loanDetailsView()
                
                Button(action: {
                    showGraph = true
                }) {
                    Text("View Graph")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)

                NavigationLink(destination: GraphView(graphData: graphData), isActive: $showGraph) {
                    EmptyView()
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("Save Results")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    private func loanDetailsView() -> some View {
        VStack(alignment: .leading) {
            Text("Monthly Payment:")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 20)
            Text("\(paymentDetails.selectedCurrencySymbol)\(String(format: "%.2f", paymentDetails.monthlyPayment))")
                .font(.system(size: 24, weight: .bold))
                .padding(.bottom, 20)
            
            Text("Total Interest:")
                .font(.system(size: 24, weight: .bold))
            Text("\(paymentDetails.selectedCurrencySymbol)\(String(format: "%.2f", paymentDetails.totalInterest))")
                .font(.system(size: 24, weight: .bold))
                .padding(.bottom, 20)
            
            Text("Total Cost:")
                .font(.system(size: 24, weight: .bold))
            Text("\(paymentDetails.selectedCurrencySymbol)\(String(format: "%.2f", paymentDetails.totalCost))")
                .font(.system(size: 24, weight: .bold))
                .padding(.bottom, 20)
        }
    }
}
