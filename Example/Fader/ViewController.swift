import UIKit
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var fader: Fader!
    private var particle = SCNParticleSystem(named: "Fire.scnp", inDirectory: "")!

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = SCNScene()
        setupScene(scene)
        scnView.scene = scene

        fader.add(target: &particle,
                  keyPath: \SCNParticleSystem.birthRate,
                  minValue: 0.0,
                  maxValue: 1000.0)

        fader.add(target: &particle,
                  keyPath: \SCNParticleSystem.particleLifeSpan,
                  minValue: 0.0,
                  maxValue: 10.0)
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

        particle.emitterShape = textShape

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

