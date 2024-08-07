import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import '../../constants.dart';
import '../../home.dart';
import '../bloc/auth_bloc.dart';

class FaceRecognition extends StatefulWidget {
  const FaceRecognition({super.key});

  @override
  FaceRecognitionState createState() => FaceRecognitionState();
}

class FaceRecognitionState extends State<FaceRecognition> {
  String _result = '';
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[1], ResolutionPreset.high);
    await _cameraController.initialize();
    _cameraController.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _isDetecting = true;
        runModel(image).then((_) async {
          _isDetecting = false;
          if (_result == "Jumana") {
            _cameraController.stopImageStream();
            await _cameraController.dispose();
            context.read<AuthBloc>().add(
                  SignInRequested(Shared.meEmail, Shared.mePass),
                );
          } else {
            _isDetecting = false;
          }
        });
      }
    });
  }

  Future<void> runModel(CameraImage image) async {
    var recognitions = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        numResults: 2,
        );
    print("recognitions,$recognitions");

    setState(() {
      _result = recognitions![0]!["label"].toString().substring(2);
    });
  }

  Future<void> _loadModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/model/model_unquant.tflite",
        labels: "assets/model/labels.txt",
        isAsset: true,
        );
    print("model loaded: $res");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Home()),
              (Route<dynamic> route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Image Detection'),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _result != "Jumana"
                      ? CameraPreview(_cameraController)
                      : const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Text('Result: $_result'),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _cameraController.dispose();
    Tflite.close();
    super.dispose();
  }
}
