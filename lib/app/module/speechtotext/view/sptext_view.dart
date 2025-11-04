import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/sptext_controller.dart';

class SpeechPage extends GetView<SpeechController> {
  const SpeechPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.initSpeech();

    return Scaffold(
      appBar: AppBar(title: const Text("Speech to Hindi Translator")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "🎙️ Speak something in English",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: Text(
                controller.recognizedText.value.isEmpty
                    ? "Listening..."
                    : controller.recognizedText.value,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              "🈶 Hindi Translation",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue[50],
              ),
              child: Text(
                controller.translatedText.value.isEmpty
                    ? "Translation will appear here..."
                    : controller.translatedText.value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            FloatingActionButton(
              onPressed: controller.toggleListening,
              backgroundColor:
              controller.isListening.value ? Colors.red : Colors.green,
              child: Icon(controller.isListening.value
                  ? Icons.mic
                  : Icons.mic_none),
            ),
          ],
        )),
      ),
    );
  }
}
