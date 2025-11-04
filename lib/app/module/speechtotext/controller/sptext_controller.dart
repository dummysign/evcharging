import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

import '../../../route/app_pages.dart';

class SpeechController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final GoogleTranslator _translator = GoogleTranslator();

  var isListening = false.obs;
  var recognizedText = ''.obs;
  var translatedText = ''.obs;

  /// Initialize speech recognition
  Future<void> initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );

    if (available) {
      print("Speech recognition initialized ✅");
    } else {
      print("Speech recognition unavailable ❌");
    }
  }

  /// Start listening
  Future<void> startListening() async {
    await _speech.listen(
      onResult: (result) async {
        recognizedText.value = result.recognizedWords;
        handleVoiceCommand(recognizedText.value);

        // Auto-translate as user speaks
        if (recognizedText.isNotEmpty) {
          var translation =
          await _translator.translate(recognizedText.value, to: 'hi');
          translatedText.value = translation.text;
        }
      },
      localeId: 'en_IN', // or use 'en_US'
      listenMode: stt.ListenMode.dictation,
    );
    isListening.value = true;
  }

  /// Stop listening
  Future<void> stopListening() async {
    await _speech.stop();
    isListening.value = false;
  }

  /// Toggle listening
  Future<void> toggleListening() async {
    if (isListening.value) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  /// 🧠 Handle recognized commands
  void handleVoiceCommand(String command) {
    if (command.contains('report')) {
      Get.offAllNamed(Routes.REPORT);
    } else if (command.contains('dashboard')) {
      Get.offAllNamed(Routes.HOMEPAGE);
    } else if (command.contains('setting') || command.contains('settings')) {
      Get.toNamed('/settings');
    } else if (command.contains('NEW SALE')) {
      Get.toNamed(Routes.SALEPOS);
    } else {
      Get.snackbar("Voice Command", "Command not recognized 👀");
    }
  }
}
