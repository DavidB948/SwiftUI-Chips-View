//
//  Chip Model
//  Chips View
//
//  Created by David Bong Chung Hua on 12/10/2021.
//

import SwiftUI

struct Chip: Identifiable, Hashable {
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}

