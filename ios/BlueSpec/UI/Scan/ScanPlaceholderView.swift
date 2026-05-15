import SwiftUI

struct ScanPlaceholderView: View {
    @State var viewModel: ScanPlaceholderViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.title)
                .font(.largeTitle)
                .fontWeight(.semibold)

            Text(viewModel.message)
                .font(.body)
                .foregroundStyle(.secondary)

            Button {
                viewModel.startMockScan()
            } label: {
                Label("Show Mock Empty State", systemImage: "magnifyingglass")
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ScanPlaceholderView(viewModel: ScanPlaceholderViewModel())
}
