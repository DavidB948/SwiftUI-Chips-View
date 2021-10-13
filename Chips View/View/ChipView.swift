//
//  ChipView.swift
//  Chips View
//
//  Created by David Bong Chung Hua on 12/10/2021.
//

import SwiftUI

struct ChipView: View {
    var titleString = "Add some chips"
    var fontSize: CGFloat = 16
    var maxLimit: Int
    @Binding var chips: [Chip]
    
    //Adding geometry effect to chip
    @Namespace var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(titleString)
                .font(.callout)
                .foregroundColor(FOREGROUND_COLOR)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(getRows(), id:\.self) { rows in
                        HStack(spacing: 6) {
                            ForEach(rows) { row in
                                RowView(chip: row)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 80, alignment: .leading)
                .padding(.vertical)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(FOREGROUND_COLOR.opacity(0.15), lineWidth: 1)
            )
        }
    }
    
    @ViewBuilder
    func RowView(chip: Chip)-> some View {
        Text(chip.text)
            .font(.system(size: fontSize))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(FOREGROUND_COLOR)
            )
            .animation(.easeInOut, value: chips)
            .overlay(
            //Limit
                Text("\(getSize(chips: chips))/\(maxLimit)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(FOREGROUND_COLOR)
                    .padding(12),
                alignment: .bottomTrailing
            )
            .foregroundColor(BACKGROUND_COLOR)
            .lineLimit(1)
            .contentShape(Capsule())
            .contextMenu{
                Button("Delete") {
                    chips.remove(at: getIndex(chip: chip))
                }
            }
            .matchedGeometryEffect(id: chip.id, in: animation)
    }
    
    func getIndex(chip: Chip)-> Int {
        let index = chips.firstIndex { currentChip in
            return chip.id == currentChip.id
        } ?? 0
        return index
    }
    
    func getRows() -> [[Chip]] {
        var rows: [[Chip]] = []
        var currentRow: [Chip] = []
        
        //calculate textWidth
        var totalWidth: CGFloat = 0
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
        
        chips.forEach { chip in
            //14+14+6+6 = 40
            totalWidth += chip.size + 40
            if totalWidth > screenWidth {
                totalWidth = (!currentRow.isEmpty || rows.isEmpty ? (chip.size + 40): 0) // resetting total width at new row to prevent from keep on adding
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(chip)
            } else {
                currentRow.append(chip)
            }
        }
        // if total Width < screen width, append to rows before exit
        if !currentRow.isEmpty {
            rows.append(currentRow)
            currentRow.removeAll()
        }
        return rows
    }
}

struct ChipView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Global function
func addChip(chips: [Chip], text: String, fontSize: CGFloat,maxLimit: Int, completion: @escaping (Bool, Chip)->()) {
    let font = UIFont.systemFont(ofSize: fontSize)
    let attributes = [NSAttributedString.Key.font: font]
    let size = (text as NSString).size(withAttributes: attributes)
    let chip = Chip(text: text, size: size.width)
    if getSize(chips: chips) + text.count < maxLimit {
        completion(false, chip)
    } else {
        completion(true, chip)
    }
}

func getSize(chips: [Chip])-> Int {
    var count: Int = 0
    chips.forEach { chip in
        count += chip.text.count
    }
    return count
}
