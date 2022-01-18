//
//  Preview.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/19.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif

#if canImport(SwiftUI) && DEBUG
import SwiftUI
import SnapKit
import Then

struct MyYellowButtonPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = UIView()
            return view
        }.previewLayout(.sizeThatFits)
    }
}
#endif
