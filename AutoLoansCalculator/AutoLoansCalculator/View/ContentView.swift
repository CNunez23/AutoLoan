import SwiftUI

struct PaymentDetails {
    var selectedCurrencySymbol: String
    var monthlyPayment: Double
    var totalInterest: Double
    var totalCost: Double
}

struct ContentView: View {
    @State private var autoPrice = ""
    @State private var loanTermMonths = ""
    @State private var interestRate = ""
    @State private var downPayment = ""
    @State private var tradeInValue = ""
    @State private var salesTax = ""
    @State private var titleRegistrationFees = ""
    @State private var monthlyPayment = 0.0
    @State private var selectedCurrencySymbol = "$"
    @State private var showSettings = false
    @State private var selectedLink: Int? = nil
    @State private var totalInterest = 0.0
    @State private var totalCost = 0.0

    @State private var savedData: [SavedData] = []
    @AppStorage("savedData") private var savedDataData: Data = Data()

    init() {
        if let decodedData = try? JSONDecoder().decode([SavedData].self, from: savedDataData) {
            self._savedData = State(initialValue: decodedData)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {

                    InputFieldView(title: "Auto Price", text: $autoPrice)
                    InputFieldView(title: "Loan Term (Months)", text: $loanTermMonths)
                    InputFieldView(title: "Interest Rate", text: $interestRate)
                    InputFieldView(title: "Down Payment", text: $downPayment)
                    InputFieldView(title: "Trade-in Value", text: $tradeInValue)
                    InputFieldView(title: "Sales Tax", text: $salesTax)
                    InputFieldView(title: "Title, Registration, and Fees", text: $titleRegistrationFees)

                    Button(action: {
                        let (calculatedTotalInterest, calculatedTotalCost) = calculateMonthlyPayment()
                        totalInterest = calculatedTotalInterest
                        totalCost = calculatedTotalCost
                        hideKeyboard()
                        selectedLink = 1
                    }) {
                        Text("Calculate")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)

                    NavigationLink(destination: ResultsView(paymentDetails: PaymentDetails(selectedCurrencySymbol: selectedCurrencySymbol, monthlyPayment: monthlyPayment, totalInterest: totalInterest, totalCost: totalCost), graphData: graphData()), tag: 1, selection: $selectedLink) {
                        EmptyView()
                    }
                    .opacity(0)

                    Text("Monthly Payment: \(selectedCurrencySymbol)\(monthlyPayment, specifier: "%.2f")")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)

                }
                .padding()
            }
            .background(Color.purple.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Car Loan Calculator", displayMode: .inline)
            .navigationBarItems(
              leading: Button(action: {
                  saveInputData()
              }) {
                  Image(systemName: "plus")
                      .resizable()
                      .frame(width: 20, height: 20)
              },
              
              trailing: NavigationLink(destination: SavedDataView(savedData: $savedData, didSelectEntry: didSelectEntry)) {
                  Image(systemName: "list.bullet")
                      .resizable()
                      .frame(width: 24, height: 24)
              }

            )
        }
    }

    private func didSelectEntry(data: SavedData) {
        autoPrice = data.autoPrice
        loanTermMonths = data.loanTermMonths
        interestRate = data.interestRate
        downPayment = data.downPayment
        tradeInValue = data.tradeInValue
        salesTax = data.salesTax
        titleRegistrationFees = data.titleRegistrationFees
    }

    private func saveInputData() {
        let inputData = SavedData(autoPrice: autoPrice, loanTermMonths: loanTermMonths, interestRate: interestRate, downPayment: downPayment, tradeInValue: tradeInValue, salesTax: salesTax, titleRegistrationFees: titleRegistrationFees)
        savedData.append(inputData)
        if let encodedData = try? JSONEncoder().encode(savedData) {
            savedDataData = encodedData
        }
    }

    private func calculateMonthlyPayment() -> (Double, Double) {
        guard let autoPriceValue = Double(autoPrice),
              let loanTermMonthsValue = Double(loanTermMonths),
              let interestRateValue = Double(interestRate),
              let downPaymentValue = Double(downPayment),
              let tradeInValueValue = Double(tradeInValue),
              let salesTaxValue = Double(salesTax),
              let titleRegistrationFeesValue = Double(titleRegistrationFees)
        else { return (0.0, 0.0) }
        
        let loanAmount = autoPriceValue - downPaymentValue - tradeInValueValue
        let taxAmount = loanAmount * (salesTaxValue / 100)
        let totalLoanAmount = loanAmount + taxAmount + titleRegistrationFeesValue
        
        let monthlyInterestRate = interestRateValue / 100 / 12
        let numerator = monthlyInterestRate * pow(1 + monthlyInterestRate, loanTermMonthsValue)
        let denominator = pow(1 + monthlyInterestRate, loanTermMonthsValue) - 1
        
        if denominator != 0 {
            monthlyPayment = totalLoanAmount * (numerator / denominator)
        } else {
            monthlyPayment = 0.0
        }
        
        let totalInterest = (monthlyPayment * loanTermMonthsValue) - totalLoanAmount
        let totalCost = totalLoanAmount + totalInterest
        
        return (totalInterest, totalCost)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func graphData() -> [Double] {
        guard let loanTermMonthsValue = Int(loanTermMonths),
              let interestRateValue = Double(interestRate),
              let downPaymentValue = Double(downPayment),
              let tradeInValueValue = Double(tradeInValue),
              let autoPriceValue = Double(autoPrice)
        else { return [] }
        
        let loanAmount = autoPriceValue - downPaymentValue - tradeInValueValue
        let totalLoanAmount = loanAmount
        let monthlyInterestRate = interestRateValue / 100 / 12
        
        var graphData: [Double] = []
        var remainingBalance = totalLoanAmount
        
        for _ in 0..<loanTermMonthsValue {
            let interest = remainingBalance * monthlyInterestRate
            let principal = monthlyPayment - interest
            remainingBalance -= principal
            graphData.append(remainingBalance)
        }
        
        return graphData
    }
}

struct SavedData: Identifiable, Codable {
    let id = UUID()
    let autoPrice: String
  let loanTermMonths: String
  let interestRate: String
  let downPayment: String
  let tradeInValue: String
  let salesTax: String
  let titleRegistrationFees: String
}

struct InputFieldView: View {
  var title: String
  @Binding var text: String

  var body: some View {
      VStack(alignment: .leading) {
          Text(title)
              .font(.system(size: 16))
              .foregroundColor(.white)
          TextField("", text: $text)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .keyboardType(.decimalPad)
        
      }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView()
  }
}

