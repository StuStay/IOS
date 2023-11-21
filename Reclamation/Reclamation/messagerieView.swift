//
//  messagerieView.swift
//  Reclamation
//
//  Created by Yassine ezzar on 14/11/2023.
//

import SwiftUI

struct messagerieView: View {
    @State private var messageText = ""
    @State var messages: [String] = [ "welcome to ChatBot" ]
    
    var body: some View {
        VStack {
            HStack {
                Text ("iBot")
                    .font(.largeTitle)
                    .bold()
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 26))
                    .foregroundColor(Color.cyan)
                
            }
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    if message.contains("[USER]") {
                        let newMessage = message.replacingOccurrences(of: "[USER]", with: "")
                        
                        HStack {
                            Spacer()
                            Text(newMessage)
                                .padding()
                                .foregroundColor(.white)
                                .background(.blue.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal,16)
                                .padding(.bottom, 10)
                        }
                    } else {
                        HStack {
                        
                        Text(message)
                            .padding()
                            .background(.blue.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 10)
                        Spacer()
                        
                    }
                    }
                    
                }
            
                HStack {
                    TextField("type something", text: $messageText)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .onSubmit {
                            sendMessage(message: messageText)
                        }
                    Button {
                        sendMessage(message: messageText)
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }.font(.system(size: 26))
                        .padding(.horizontal, 10)
                    
                }
                .padding()
            }
        }
    }
    func sendMessage(message: String) {
        withAnimation {
            messages.append("[USER]" + message)
            self.messageText = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                messages.append(getBotResponse(message: message))
                
            }
        }
    }
    
    
    
    struct messagerieView_Previews: PreviewProvider {
        static var previews: some View {
            messagerieView()
        }
    }
    
}
