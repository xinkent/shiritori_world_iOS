import SwiftUI

struct CustomTextFieldView: UIViewRepresentable {

    private let title: String?
    @Binding var text: String
    let onEditingChanged: (Bool) -> Void
    let onCommit: () -> Void

    let textField = UITextField()

    init(title: String?, text: Binding<String>, onEditingChanged: @escaping (Bool) -> Void = { _ in }, onCommit: @escaping () -> Void = {}) {
        self.title = title
        self._text = text
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    func makeUIView(context: UIViewRepresentableContext<CustomTextFieldView>) -> UITextField {
        textField.placeholder = title
        textField.delegate = context.coordinator
        textField.text = self.text
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextFieldView>) {
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return CustomTextFieldView.Coordinator(parent: self)
    }

    
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: CustomTextFieldView
        let onEditingChanged: (Bool) -> Void

        init(parent: CustomTextFieldView, onEditingChanged: @escaping (Bool) -> Void = {_ in}) {
            self.parent = parent
            self.onEditingChanged = onEditingChanged
            super.init()
            parent.textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
            parent.textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
            parent.textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            parent.textField.addTarget(self, action: #selector(textFieldEditingDidEndOnExit(_:)), for: .editingDidEndOnExit)
        }
        
        @objc func textFieldEditingDidBegin(_ textField: UITextField) {
            parent.onEditingChanged(true)
        }

        @objc func textFieldEditingDidEnd(_ textField: UITextField) {
            parent.onEditingChanged(false)
        }

        @objc func textFieldEditingChanged(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        @objc func textFieldEditingDidEndOnExit(_ textField: UITextField) {
            parent.onCommit()
        }
    }


}
