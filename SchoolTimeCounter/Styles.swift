import SwiftUI

struct BoldText: View {
    var text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .bold()
    }
}

struct PaddingDivider: View {
    var body: some View {
        Divider()
            .padding(.vertical)
    }
}
