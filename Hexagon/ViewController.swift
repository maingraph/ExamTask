import UIKit

class ViewController: UIViewController {

    // MARK: – UI-элементы
    private lazy var shapeContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    private lazy var backgroundControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Color", "Image"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    private lazy var animationControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["None", "Rotate", "Move", "Opacity"])
        sc.selectedSegmentIndex = 0
        return sc
    }()

    // MARK: – ShapeLayer
    private let shapeLayer = CAShapeLayer()
    private var originalPosition: CGPoint = .zero
    private var didSetupShape = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Добавляем в иерархию
        [shapeContainer, backgroundControl, animationControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        setupConstraints()

        // Подключаем действия
        backgroundControl.addTarget(self, action: #selector(backgroundChanged), for: .valueChanged)
        animationControl.addTarget(self, action: #selector(animationChanged), for: .valueChanged)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Первый раз — настраиваем слой после layout
        guard !didSetupShape else { return }
        setupShapeLayer()
        originalPosition = shapeLayer.position
        updateBackground()
        updateAnimation()
        didSetupShape = true
    }

    // MARK: – Layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // shapeContainer
            shapeContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            shapeContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            shapeContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            shapeContainer.heightAnchor.constraint(equalToConstant: 300),

            // backgroundControl
            backgroundControl.topAnchor.constraint(equalTo: shapeContainer.bottomAnchor, constant: 20),
            backgroundControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backgroundControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // animationControl
            animationControl.topAnchor.constraint(equalTo: backgroundControl.bottomAnchor, constant: 20),
            animationControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            animationControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    // MARK: – Шестигранник
    private func setupShapeLayer() {
        let w = shapeContainer.bounds.width
        let h = shapeContainer.bounds.height
        let r = min(w, h) / 3
        let path = UIBezierPath()
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi/3 - .pi/2
            let pt = CGPoint(
                x: w/2 + cos(angle) * r,
                y: h/2 + sin(angle) * r
            )
            i == 0 ? path.move(to: pt) : path.addLine(to: pt)
        }
        path.close()

        shapeLayer.path = path.cgPath
        shapeLayer.frame = shapeContainer.bounds
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeContainer.layer.addSublayer(shapeLayer)
    }

    // MARK: – Фон
    @objc private func backgroundChanged() {
        updateBackground()
    }
    private func updateBackground() {
        switch backgroundControl.selectedSegmentIndex {
        case 0:
            shapeLayer.fillColor = UIColor.systemTeal.cgColor
        case 1:
            if let img = UIImage(named: "Pattern") {
                shapeLayer.fillColor = UIColor(patternImage: img).cgColor
            }
        default: break
        }
    }

    // MARK: – Анимации
    @objc private func animationChanged() {
        updateAnimation()
    }
    private func updateAnimation() {
        shapeLayer.removeAllAnimations()
        switch animationControl.selectedSegmentIndex {
        case 1: // Rotate
            let a = CABasicAnimation(keyPath: "transform.rotation.z")
            a.toValue = 2 * Double.pi
            a.duration = 2
            a.repeatCount = .infinity
            shapeLayer.add(a, forKey: "rotate")

        case 2: // Move
            let a = CABasicAnimation(keyPath: "position.x")
            a.fromValue = originalPosition.x
            a.toValue   = originalPosition.x + 80
            a.duration = 1
            a.autoreverses = true
            a.repeatCount = .infinity
            shapeLayer.add(a, forKey: "move")

        case 3: // Opacity
            let a = CABasicAnimation(keyPath: "opacity")
            a.fromValue = 1
            a.toValue   = 0.2
            a.duration = 1
            a.autoreverses = true
            a.repeatCount = .infinity
            shapeLayer.add(a, forKey: "fade")

        default:
            break
        }
    }
}
