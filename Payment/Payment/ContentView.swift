//
//  ContentView.swift
//  Payment
//
//  Created by hama boualeg on 8/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var paymentamount: String = ""
    @State private var paymentDate: Date = Date()
    @State private var selectedPaymenMethod: String = "Credit Card"
    @State private var numberOfRoomates: Int = 1
    @State private var isRecurringPayment: Bool = false
    @State private var recurringPaymentFrequency: String = "Monthly"
    var body: some View {
        NavigationView{
            VStack {Color.cyan
                    .frame(width: 376, height: 50)
                
                Form {
                    Section(header: Text("Payment Information").font(.headline).foregroundColor(.cyan)) {
                        Text("Payment Amount:")
                            .font(.headline)
                        
                        TextField("Enter Payment Amount",text: $paymentamount)
                            .padding(2)
                        Text ("Payment Date:")
                            .font(.headline)
                        DatePicker("Select Payment Date", selection: $paymentDate, displayedComponents: .date)
                            .padding(2)
                        Text("Payment Method:")
                            .font(.headline)
                        Picker("Select Payment Method", selection: $selectedPaymenMethod){
                            Text("Credit Card").tag("Credit Card")
                            Text("Bank Transfer").tag("Bank Transfer")
                        }
                        .padding(2)
                        
                        Text("Number of Roomates:")
                            .font(.headline)
                        Stepper(value: $numberOfRoomates, in: 1...10) {
                            Text("\(numberOfRoomates) Roomates")
                        }
                            
                            
                            
                            Toggle(isOn: $isRecurringPayment) {
                                Text("Recurring Payment").font(.headline)
                            }
                            .padding(2)
                            
                            
                            if isRecurringPayment{
                                Text("Payment Frequency")
                                    .font(.headline)
                                Picker("Select Payment Frequency", selection: $recurringPaymentFrequency) {
                                    Text("Monthly").tag("Monthly")
                                    Text("Yearly").tag("Yearly")
                                }
                                .padding()
                                
                            }
                        
                        
                        
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            
                        }) {
                            Text("Submit")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .background(Color.cyan)
                        .cornerRadius(10)
                    }
                    Spacer()
                    
                }}
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Text("Payment Form").font(.title).foregroundColor(.cyan).padding())

        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
