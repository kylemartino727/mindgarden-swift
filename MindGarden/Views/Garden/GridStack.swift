//
//  GridStack.swift
//  MindGarden
//
//  Created by Mark Jones on 6/19/21.
//

import Foundation
import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack(spacing: 0){
                    ForEach(0 ..< columns, id: \.self) { column in
                        if row == 0 && column == 0 {
                            content(row, column)
                                .cornerRadius(15, corners: [.topLeft])
                        } else if row == 4 && column == 0 {
                            content(row, column)
                                .cornerRadius(15, corners: [.bottomLeft])
                        } else if row == 0 && column == 6 {
                            content(row, column)
                                .cornerRadius(15, corners: [.topRight])
                        } else if row == 4 && column == 6 {
                            content(row, column)
                                .cornerRadius(15, corners: [.bottomRight])
                        } else {
                            content(row, column)
                        }
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}
