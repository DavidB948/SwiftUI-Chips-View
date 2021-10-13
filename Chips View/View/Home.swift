//
//  Home.swift
//  Chips View
//
//  Created by David Bong Chung Hua on 12/10/2021.
//

import SwiftUI

struct Home: View {
    @State var text: String = ""
    @State var chips: [Chip] = []
    @State var showAlert: Bool = false
    var body: some View {
        VStack {
            Text("Filter \nMenus")
                .font(.system(size: 38, weight: .bold))
                .foregroundColor(FOREGROUND_COLOR)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            //Custom Chip View
            ChipView(maxLimit: 150, chips: $chips)
                .frame(height: 280) //default height
                .padding(.top, 20)
            
            //TextField
            TextField("apple", text: $text)
                .font(.title)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(FOREGROUND_COLOR.opacity(0.2), lineWidth: 1)
                )
                .environment(\.colorScheme, .dark)
                .padding(.vertical, 20)
            
            //Add Button
            Button {
                addChip(chips: chips, text: text, fontSize: FONT_SIZE, maxLimit: 150) { alert, chip in
                    if alert {
                        showAlert.toggle()
                    } else {
                        // adding chip
                        chips.append(chip)
                        text = "" // resetting text after added
                    }
                }
            } label: {
                Text("Add Tag")
                    .fontWeight(.semibold)
                    .foregroundColor(BACKGROUND_COLOR)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 45)
                    .background(FOREGROUND_COLOR)
                    .cornerRadius(10)
            }
            .disabled(text == "")
            .opacity(text == "" ? 0.6:1)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            BACKGROUND_COLOR
                .ignoresSafeArea()
        )
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Chip limit exceeded. Try to delete some chips!"), dismissButton: .destructive(Text("Ok")))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
