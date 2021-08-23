//
//  CameraView.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/06/07.
//

import UIKit
import AVFoundation

protocol CameraViewProtocol {
    func photoOutput(uiImage: UIImage) -> Void
}

class CameraView: UIView {

    private var _delegate: CameraViewProtocol?
    
    private var pinchGesture = UIPinchGestureRecognizer()
    private var currentZoom: CGFloat = 1
    private let ZOOM_MINIMUM: CGFloat = 1
    private let ZOOM_MAXIMUM: CGFloat = 6
    private var preZoom: CGFloat = 1
    
    var delegate: CameraViewProtocol? {
        set(p){
            _delegate = p
        }
        get{
            return _delegate
        }
    }
    // デバイスからの入力と出力を管理するオブジェクトの作成
    private var captureSession: AVCaptureSession!
    // カメラデバイスそのものを管理するオブジェクトの作成
    // メインカメラの管理オブジェクトの作成
    private var mainCamera: AVCaptureDevice?
    // インカメの管理オブジェクトの作成
    private var innerCamera: AVCaptureDevice?
    // 現在使用しているカメラデバイスの管理オブジェクトの作成
    private var currentDevice: AVCaptureDevice?
    // キャプチャーの出力データを受け付けるオブジェクト
    private var photoOutput : AVCapturePhotoOutput?
    // プレビュー表示用のレイヤ
    private var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    
    private var cameraView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        setup()
    }
    
    private func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
    }
    
    private func setup(){
        captureSession = AVCaptureSession()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
        
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGestureRecognized(_:)))
        self.addGestureRecognizer(self.pinchGesture)
    }
    
    func shutter(){
        let settings = AVCapturePhotoSettings()
        // フラッシュの設定
        settings.flashMode = .auto
        // 撮影された画像をdelegateメソッドで処理
        self.photoOutput?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    
    @IBAction func pinchGestureRecognized(_ sender: UIPinchGestureRecognizer) {
        
        if sender.state == .ended {
            preZoom = currentZoom
            return
        }
        
        currentZoom = preZoom * sender.scale
        
        if currentZoom < ZOOM_MINIMUM {
            currentZoom = ZOOM_MINIMUM
        }
        else if currentZoom > ZOOM_MAXIMUM {
            currentZoom = ZOOM_MAXIMUM
        }
        
        do {
            try self.currentDevice?.lockForConfiguration()
            self.currentDevice?.videoZoomFactor = currentZoom
            currentDevice?.unlockForConfiguration()
        }
        catch {
            print(error)
        }
    
        
    }
    
}

//MARK: AVCapturePhotoCaptureDelegateデリゲートメソッド
extension CameraView: AVCapturePhotoCaptureDelegate{
    // 撮影した画像データが生成されたときに呼び出されるデリゲートメソッド
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            // Data型をUIImageオブジェクトに変換
            let uiImage = UIImage(data: imageData)!
            
            _delegate?.photoOutput(uiImage: uiImage)
        }
    }
}

//MARK: カメラ設定メソッド
extension CameraView{
    // カメラの画質の設定
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }

    // デバイスの設定
    func setupDevice() {
        // カメラデバイスのプロパティ設定
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        // プロパティの条件を満たしたカメラデバイスの取得
        let devices = deviceDiscoverySession.devices

        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                mainCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                innerCamera = device
            }
        }
        // 起動時のカメラを設定
        currentDevice = mainCamera
    }

    // 入出力データの設定
    func setupInputOutput() {
        do {
            // 指定したデバイスを使用するために入力を初期化
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            // 指定した入力をセッションに追加
            captureSession.addInput(captureDeviceInput)
            
            // 出力データを受け取るオブジェクトの作成
            photoOutput = AVCapturePhotoOutput()
            // 出力ファイルのフォーマットを指定
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }

    // カメラのプレビューを表示するレイヤの設定
    func setupPreviewLayer() {
        // 指定したAVCaptureSessionでプレビューレイヤを初期化
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // プレビューレイヤが、カメラのキャプチャーを縦横比を維持した状態で、表示するように設定
//        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // プレビューレイヤの表示の向きを設定
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait

        self.cameraPreviewLayer?.frame = self.bounds
        self.layer.addSublayer(self.cameraPreviewLayer!)
    }

}
