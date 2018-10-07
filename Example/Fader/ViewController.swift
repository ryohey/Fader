import UIKit
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var fader: Fader!
    private var particle = SCNParticleSystem(named: "Fire.scnp", inDirectory: "")!
    private var text = SCNText(string: "fader", extrusionDepth: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = SCNScene()
        setupScene(scene)
        scnView.scene = scene

        fader.add(target: particle,
                  keyPath: \SCNParticleSystem.birthRate,
                  minValue: 0.0,
                  maxValue: 1000.0)

        fader.add(target: particle,
                  keyPath: \SCNParticleSystem.particleLifeSpan,
                  minValue: 0.0,
                  maxValue: 10.0)

        fader.add(target: particle,
                  keyPath: \SCNParticleSystem.particleVelocity,
                  minValue: 0.0,
                  maxValue: 10.0)

        fader.add(target: particle,
                  keyPath: \SCNParticleSystem.particleSize,
                  minValue: 0.0,
                  maxValue: 10.0)

        fader.add(target: particle,
                  keyPath: \SCNParticleSystem.isAffectedByGravity)

        fader.add(target: self,
                  keyPath: \UIViewController.title)
    }

    private func setupScene(_ scene: SCNScene) {
        do {
            let node = SCNNode()
            node.camera = SCNCamera()
            node.position = SCNVector3(x: 0, y: 0, z: 100)
            scene.rootNode.addChildNode(node)
        }

        let container = SCNNode()

        text.flatness = 0.1
        text.chamferRadius = 0.02

        do {
            let node = SCNNode(geometry: text)
            node.geometry?.materials.append(SCNMaterial())
            node.geometry?.materials.first?.diffuse.contents = UIColor(white: 0.9, alpha: 1)
            container.addChildNode(node)
        }

        // particle
        do {
            let node = SCNNode()
            particle.emitterShape = text
            node.addParticleSystem(particle)
            container.addChildNode(node)
        }

        if let particleShapePosition = particle.emitterShape?.boundingSphere.center {
            container.pivot = SCNMatrix4MakeTranslation(
                particleShapePosition.x,
                particleShapePosition.y,
                0)
        }

        scene.rootNode.addChildNode(container)
    }
}

