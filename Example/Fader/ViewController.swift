import UIKit
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var fader: Fader!

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = SCNScene()
        setupScene(scene)
        scnView.scene = scene
    }

    private func setupScene(_ scene: SCNScene) {
        do {
            let node = SCNNode()
            node.camera = SCNCamera()
            node.position = SCNVector3(x: 0, y: 0, z: 100)
            scene.rootNode.addChildNode(node)
        }

        let textShape = SCNText(string: "Fader", extrusionDepth: 1)
        textShape.flatness = 0.0

        guard var particle = SCNParticleSystem(named: "Fire.scnp", inDirectory: "") else {
            fatalError()
        }

        particle.emitterShape = textShape
        fader.add(target: &particle,
                  keyPath: \SCNParticleSystem.birthRate,
                  minValue: 0.0,
                  maxValue: 1000.0)

        let node = SCNNode()
        if let particleShapePosition = particle.emitterShape?.boundingSphere.center {
            node.pivot = SCNMatrix4MakeTranslation(
                particleShapePosition.x,
                particleShapePosition.y,
                0)
        }
        node.addParticleSystem(particle)

        scene.rootNode.addChildNode(node)
    }
}

