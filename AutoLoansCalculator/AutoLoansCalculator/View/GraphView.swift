import SwiftUI
import SwiftUICharts

struct GraphView: View {
    let graphData: [Double]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("GraphEndColor"), Color("GraphStartColor")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Loan Balance Over Time")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity)
                
              Spacer()
                
                ZStack {
                    Color.white.opacity(0.3)
                        .frame(maxHeight: 200)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                    
                    LineView(data: graphData, title: "Loan Balance", legend: "Monthly Payments")
                        .frame(maxHeight: 200)
                        .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(graphData: [1000, 2000, 1500, 3000, 2500, 4000])
            .previewDevice("iPhone 12")
    }
}
