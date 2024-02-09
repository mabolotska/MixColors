//
//  ViewController.swift
//  MixColors
//
//  Created by Maryna Bolotska on 08/02/24.
//

import UIKit
import SnapKit
import Combine


class ViewController: UIViewController {
    var cancellable: AnyCancellable?
    let black10 = UIColor(white: 0, alpha: 0.7)
//    var selectedColor: UIColor?
    var secondSelectedColor: UIColor?
//    lazy var newColor = selectedColor?.add(overlay: secondSelectedColor ?? UIColor.black)
    
    private let oneStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 25
        return stack
    }()
    
    private let firstColorLabl: UILabel = {
        let label = UILabel()
        label.text = "Blue"
        label.textAlignment = .center
        return label
    }()
    
    private let blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private let plusLabl: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.textAlignment = .center
        return label
    }()
    
    private let secondColorLabl: UILabel = {
        let label = UILabel()
        label.text = "Red"
        label.textAlignment = .center
        return label
    }()
    private let redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    private let equalLabl: UILabel = {
        let label = UILabel()
        label.text = "="
        label.textAlignment = .center
        return label
    }()
    
    private let thirdColorLabl: UILabel = {
        let label = UILabel()
        label.text = "Purple"
        label.textAlignment = .center
        return label
    }()
    
   
    private let purpleView: UIView = {
        let view = UIView()
       
        return view
    }()
    
    private var selectedColor: UIColor = .purple {
        didSet {
            purpleView.backgroundColor = selectedColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        purpleView.backgroundColor = .purple
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        blueView.addGestureRecognizer(tapGestureRecognizer)
        blueView.isUserInteractionEnabled = true
        let tapGestureRecognizerTwo = UITapGestureRecognizer(target: self, action: #selector(secondViewTapped))
        redView.addGestureRecognizer(tapGestureRecognizerTwo)
        redView.isUserInteractionEnabled = true
    }
    
    @objc func viewTapped() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.blueView.backgroundColor!
    
        self.cancellable = picker.publisher(for: \.selectedColor)
            .sink { color in
                self.selectedColor = color // Assign selected color to class property
               print(self.selectedColor)
                
                let colorName = self.closestColorName(for: color)
                print("Selected color name: \(String(describing: colorName))")
                self.firstColorLabl.text = "\(colorName ?? "blue")"
                DispatchQueue.main.async {
                    self.blueView.backgroundColor = color
                }
            }
    
        self.present(picker, animated: true, completion: nil)
        
        
//        if let selectedColor = self.selectedColor {
//                   print(selectedColor)
//               } else {
//                   print("Selected color is nil.")
//               }
        
//        var newColor = selectedColor?.add(overlay: black10)
//        blueView.backgroundColor = newColor
    }

    @objc func secondViewTapped() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.redView.backgroundColor!
    
        self.cancellable = picker.publisher(for: \.selectedColor)
            .sink { color in
                self.secondSelectedColor = color // Assign selected color to class property
                print(self.secondSelectedColor)
                
                let colorName = self.closestColorName(for: color)
                print("Selected color name: \(String(describing: colorName))")
                self.secondColorLabl.text = "\(colorName ?? "blue")"
                DispatchQueue.main.async {
                    self.redView.backgroundColor = color
                }
            }
    
        self.present(picker, animated: true, completion: nil)
    }
    
    
 
    
    func closestColorName(for color: UIColor) -> String? {
        let colorNames: [UIColor: String] = [
            UIColor.red: "Red",
            UIColor.green: "Green",
            UIColor.blue: "Blue",
            UIColor.white: "White",
            UIColor.black: "Black",
            UIColor.yellow: "Yellow",
            UIColor.purple: "Purple",
            UIColor.gray: "Gray"
        ]
        
        // Convert the input color to RGB
        guard let components = color.cgColor.components else {
            return nil
        }
        print(components)
        
        // Ensure the color has enough components
        guard components.count >= 3 else {
            return nil
        }

        let r1 = components[0]
        let g1 = components[1]
        let b1 = components[2]

        var closestColorName: String?
        var closestDistance: CGFloat = CGFloat.greatestFiniteMagnitude

        for (colorValue, name) in colorNames {
            // Get the RGB components of the predefined color
            guard let predefinedComponents = colorValue.cgColor.components else {
                continue
            }
            
            // Ensure predefined color has enough components
            guard predefinedComponents.count >= 3 else {
                continue
            }

            let r2 = predefinedComponents[0]
            let g2 = predefinedComponents[1]
            let b2 = predefinedComponents[2]

            // Calculate the Euclidean distance between the two colors
            let distance = sqrt(pow(r2 - r1, 2) + pow(g2 - g1, 2) + pow(b2 - b1, 2))

            // Update the closest color if this color is closer
            if distance < closestDistance {
                closestDistance = distance
                closestColorName = name
            }
        }

        return closestColorName
    }
}



extension ViewController {
    func setupUI() {
        view.backgroundColor = .white
        title = "MixColors"
        view.addSubview(oneStack)
        oneStack.addArrangedSubview(firstColorLabl)
        oneStack.addArrangedSubview(blueView)
        oneStack.addArrangedSubview(plusLabl)
        oneStack.addArrangedSubview(secondColorLabl)
        oneStack.addArrangedSubview(redView)
        oneStack.addArrangedSubview(equalLabl)
        oneStack.addArrangedSubview(thirdColorLabl)
        oneStack.addArrangedSubview(purpleView)
        
        
        
      
        
        oneStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        blueView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
        redView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
        purpleView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
    }
}


extension ViewController: UIColorPickerViewControllerDelegate {
    
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.redView.backgroundColor = viewController.selectedColor
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.cancellable?.cancel()
            print(self.cancellable == nil)
        }
    }
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            self.view.backgroundColor = viewController.selectedColor
        
    }
    
}



extension UIColor {

    func add(overlay: UIColor) -> UIColor {
        var bgR: CGFloat = 0
        var bgG: CGFloat = 0
        var bgB: CGFloat = 0
        var bgA: CGFloat = 0
        
        var fgR: CGFloat = 0
        var fgG: CGFloat = 0
        var fgB: CGFloat = 0
        var fgA: CGFloat = 0
        
        self.getRed(&bgR, green: &bgG, blue: &bgB, alpha: &bgA)
        overlay.getRed(&fgR, green: &fgG, blue: &fgB, alpha: &fgA)
        
        let r = fgA * fgR + (1 - fgA) * bgR
        let g = fgA * fgG + (1 - fgA) * bgG
        let b = fgA * fgB + (1 - fgA) * bgB
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
