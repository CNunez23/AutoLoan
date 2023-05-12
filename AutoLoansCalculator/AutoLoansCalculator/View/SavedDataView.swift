import SwiftUI

struct SavedDataView: View {
    @Binding var savedData: [SavedData]
    var didSelectEntry: (SavedData) -> Void

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(savedData.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Auto Price: \(savedData[index].autoPrice)")
                        Text("Loan Term (Months): \(savedData[index].loanTermMonths)")
                        Text("Interest Rate: \(savedData[index].interestRate)")
                        Text("Down Payment: \(savedData[index].downPayment)")
                        Text("Trade-in Value: \(savedData[index].tradeInValue)")
                        Text("Sales Tax: \(savedData[index].salesTax)")
                        Text("Title, Registration, and Fees: \(savedData[index].titleRegistrationFees)")
                        
                        HStack {
                            Button(action: {
                                didSelectEntry(savedData[index])
                            }) {
                                Text("View Details")
                                    .foregroundColor(.white)
                                    .frame(width: 120, height: 30)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                savedData.remove(at: index)
                            }) {
                                Text("Delete")
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 30)
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .padding(.top)
        }
        .navigationBarTitle("Saved Data", displayMode: .inline)
    }
}
