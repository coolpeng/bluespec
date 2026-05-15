import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            ScanPlaceholderView(viewModel: ScanPlaceholderViewModel())
                .navigationTitle("BlueSpec")
        }
    }
}

#Preview {
    RootView()
}
