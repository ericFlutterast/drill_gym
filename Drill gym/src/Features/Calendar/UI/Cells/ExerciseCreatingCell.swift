import UIKit

class ExerciseCreatingCell: UITableViewCell{
    var onSave: (((String, Int, Int, Float?) -> Void))?
    
    private lazy var hStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var labelX = {
        let label = UILabel()
        label.text = "X"
        label.textColor = .white
        return label
    } ()
    
    private lazy var saveButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .systemYellow
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    private lazy var exerciseNameTextInput = createTextField(placeHolder: "Exercise name")
    private lazy var approachesTextInput = createTextField(placeHolder: "Approaches", keyboardType: .numberPad)
    private lazy var repeatsTextInput = createTextField(placeHolder: "Repeates", keyboardType: .numberPad)
    private lazy var weightTextInput = createTextField(placeHolder: "Kg", keyboardType: .numberPad)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray
        configurateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
    
    private func configurateLayout() {
        let row = hStack
        exerciseNameTextInput.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        labelX.setContentHuggingPriority(.required, for: .horizontal)
        repeatsTextInput.setContentHuggingPriority(.defaultHigh ,for: .horizontal)
        saveButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        row.addArrangedSubview(exerciseNameTextInput)
        row.addArrangedSubview(approachesTextInput)
        row.addArrangedSubview(labelX)
        row.addArrangedSubview(repeatsTextInput)
        row.addArrangedSubview(weightTextInput)
        row.addArrangedSubview(saveButton)
        contentView.addSubview(row)
        
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            row.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            row.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            labelX.centerYAnchor.constraint(equalTo: hStack.centerYAnchor),
            saveButton.centerYAnchor.constraint(equalTo: hStack.centerYAnchor),
            
            approachesTextInput.widthAnchor.constraint(equalToConstant: 50),
            repeatsTextInput.widthAnchor.constraint(equalToConstant: 50),
            weightTextInput.widthAnchor.constraint(equalToConstant: 50),
            exerciseNameTextInput.widthAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    @IBAction private func save() {
        guard let onSave = onSave else {return}
        onSave(
            exerciseNameTextInput.text ?? "",
            Int(approachesTextInput.text ?? "0") ?? 0 ,
            Int(repeatsTextInput.text ?? "0") ?? 0,
            weightTextInput.text != nil ? Float(weightTextInput.text!) : nil
        )
        self.endEditing(true)
    }
    
    private func createTextField(placeHolder: String = "", keyboardType: UIKeyboardType = .default) -> UITextField {
        let edgePadding = UIView.init(frame: .init(x: 0, y: 0, width: 10, height: 5))
        let textField = UITextField()
        textField.backgroundColor = .systemGray2
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString(placeHolder, comment: placeHolder))
        textField.tintColor = .systemYellow
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.leftView = edgePadding
        textField.rightView = edgePadding
        textField.layer.cornerRadius = 10
        textField.keyboardType = keyboardType
        textField.textColor = .white
        textField.delegate = self
        return textField
    }
}

extension ExerciseCreatingCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
