import SwiftUI
import SwiftUICharts

struct LoanChartView: View {
    var loanTermMonths: Int
    var monthlyPayment: Double
    var totalLoanAmount: Double
    var monthlyInterestRate: Double
    
    var body: some View {
        VStack {
            Text("Interest and Remaining Balance over Loan Term")
                .font(.title)
                .padding(.bottom, 20)
            
            LineView(data: interestOverLoanTerm(), title: "Interest", legend: "Monthly Interest")
                .frame(height: 200)
            
            LineView(data: remainingBalanceOverLoanTerm(), title: "Remaining Balance", legend: "Monthly Remaining Balance")
                .frame(height: 200)
        }
    }
    
    func interestOverLoanTerm() -> [Double] {
        var interestData: [Double] = []
        var remainingBalance = totalLoanAmount
        
        for _ in 0..<loanTermMonths {
            let interest = remainingBalance * monthlyInterestRate
            interestData.append(interest)
            let principal = monthlyPayment - interest
            remainingBalance -= principal
        }
        
        return interestData
    }
    
    func remainingBalanceOverLoanTerm() -> [Double] {
        var remainingBalanceData: [Double] = []
        var remainingBalance = totalLoanAmount
        
        for _ in 0..<loanTermMonths {
            let interest = remainingBalance * monthlyInterestRate
            let principal = monthlyPayment - interest
            remainingBalance -= principal
            remainingBalanceData.append(remainingBalance)
        }
        
        return remainingBalanceData
    }
}

struct LoanChartView_Previews: PreviewProvider {
    static var previews: some View {
        LoanChartView(loanTermMonths: 60, monthlyPayment: 399.71, totalLoanAmount: 18000, monthlyInterestRate: 0.002917)
    }
}

