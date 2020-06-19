import 'dart:io';

import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class SharingService {
  String _path, fileName, _extension;
  Map<String, String> _paths;
  bool _multiPick = false, _loadingPath = false, fileSelected = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = new TextEditingController();

  // handleFileSend(fileName, filePath, mime, ip) {}

  handleFileSelect() {
    openFileExplorer();
  }

  // handles what happens after file is selected and device chosen
  handleFileShare(int index) {
    // peerIndex = index;
  }

  // handles what happens after file is accepted
  handleFileReceive() {
    // setState(() {
    //   pearPanel = PearPanel.receiving;
    // });
  }

  // cancels file sharing
  cancelShare() {
    // _pc.close();
  }

  // allows user to upload files
  openFileExplorer() async {
    _controller.addListener(() => _extension = _controller.text);
    String initialDirectory;
    if (Platform.isMacOS || Platform.isWindows) {
      initialDirectory = (await getApplicationDocumentsDirectory()).path;
      final result = await showOpenPanel(
          allowsMultipleSelection: true, initialDirectory: initialDirectory);
      _path = '${result.paths.join('\n')}';
    } else if (Platform.isIOS || Platform.isAndroid) {
      // setState(() => _loadingPath = true);
      _loadingPath = true;
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType,
              allowedExtensions: (_extension?.isNotEmpty ?? false)
                  ? _extension?.replaceAll(' ', '')?.split(',')
                  : null);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType,
              allowedExtensions: (_extension?.isNotEmpty ?? false)
                  ? _extension?.replaceAll(' ', '')?.split(',')
                  : null);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
    }
    // if (!mounted) return;
    // setState(() {
    // pearPanel = PearPanel.sharing;
    _loadingPath = false;
    fileName = _path != null
        ? _path.split('/').last
        : _paths != null ? _paths.keys.toString() : '...';
    // });
    await Future.delayed(const Duration(milliseconds: 600), () {
      if ('$fileName' != null) {
        fileSelected = true;
        // _pc.open();
      }
    });
  }
}
