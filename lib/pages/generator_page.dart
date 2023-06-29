import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrCodePage extends StatefulWidget {
  final String groupId;

  const GenerateQrCodePage({Key? key, required this.groupId}) : super(key: key);

  @override
  State<GenerateQrCodePage> createState() => _GenerateQrCodePageState();
}

class _GenerateQrCodePageState extends State<GenerateQrCodePage> {
  late String qrData;
  final qrText = TextEditingController();

  @override
  void initState() {
    super.initState();
    qrData =
        'https://customer-shopping-menu.vercel.app/menu?id=${widget.groupId}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'QR Code Menu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Generated QR Code",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 250,
                  child: QrImageView(
                    data: qrData,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Divider(
                height: 20.0,
                thickness: 1.0,
                color: Colors.black,
                endIndent: 42.0,
                indent: 42.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: const Text(
                  "*Mã QR Code chỉ dành cho các thành viên trong tour, quý khách vui lòng không chia sẻ QR Code cho người ngoài!",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.red),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
