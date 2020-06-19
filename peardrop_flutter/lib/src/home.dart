// this is the main page of the app (the first you see) and will show nearby devices that (when clicked on) will allow you to select file(s) to share

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peardrop/src/utilities/sharing_service.dart';
import 'package:peardrop/src/utilities/word_list.dart';
import 'package:peardrop/src/widgets/bottom_version.dart';
import 'package:peardrop/src/widgets/devices_grid.dart';
import 'package:peardrop/src/widgets/file_select_body.dart';
import 'package:peardrop/src/widgets/peardrop_appbar.dart';
import 'package:peardrop/src/widgets/sliding_panel_accept.dart';
import 'package:peardrop/src/widgets/sliding_panel_receive.dart';
import 'package:peardrop/src/widgets/sliding_panel_send.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'utilities/nearby_device.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum PearPanel { sharing, receiving, accepting }

class _HomePageState extends State<HomePage> {
  PanelController _pc = new PanelController();
  List<Device> devices = [];
  int peerIndex = 0;
  InternetAddress deviceId = new InternetAddress('190.160.225.16');
  PearPanel pearPanel = PearPanel.sharing;
  bool fileSelected = false;
  SharingService share;

  @override
  void initState() {
    super.initState();
    share = new SharingService();
    // TODO: determine how best to use deviceInfo | deviceId = DeviceDetails().getDeviceDetails() as String;
    // dummy data
    devices.add(Device(Icons.phone_iphone, InternetAddress('140.70.235.92')));
    devices.add(Device(Icons.laptop_windows, InternetAddress('3.219.241.180')));
  }

  // main build function
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Color(0xff293851),
        // appBar: PearDropAppBar().getAppBar('PearDrop'),
        body: _getBody(),
        bottomNavigationBar: BottomVersionBar(
          version: '1.0.0+0',
        ),
      ),
    );
  }

// returns main app body
  Widget _getBody() {
    if (fileSelected) {
      double _panelHeightClosed = 90.0;
      // double _panelHeightOpen = MediaQuery.of(context).size.height * 0.55;
      double _panelHeightOpen = MediaQuery.of(context).size.height * 0.85;
      return Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            controller: _pc,
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            defaultPanelState: PanelState.CLOSED,
            backdropEnabled: true,
            renderPanelSheet: false,
            backdropOpacity: 0.2,
            isDraggable: false,
            body: DevicesGrid(
              devices: devices,
              func: share.handleFileShare,
            ),
            collapsed: BottomVersionBar(
              version: '1.0.0+0',
              deviceName: WordList().ipToWords(deviceId),
            ),
            panelBuilder: (sc) => _getPanel(sc),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {}),
          ),
        ],
      );
    } else {
      return FileSelectBody(
        func: share.handleFileSelect,
        deviceName: WordList().ipToWords(deviceId),
      );
    }
  }

// returns panel based on situation
  Widget _getPanel(ScrollController sc) {
    if (pearPanel == PearPanel.sharing) {
      return SlidingPanelSend(
        peerDevice: devices[peerIndex],
        sc: sc,
        fileName: share.fileName,
        cancel: CloseButton(
          onPressed: () => share.cancelShare(),
        ),
      );
    } else if (pearPanel == PearPanel.receiving) {
      return SlidingPanelReceive(
        peerDevice: devices[peerIndex],
        sc: sc,
        fileName: share.fileName,
        cancel: CloseButton(
          onPressed: () => share.cancelShare(),
        ),
      );
    } else if (pearPanel == PearPanel.accepting) {
      return SlidingPanelAccept(
        peerDevice: devices[peerIndex],
        sc: sc,
        func: share.handleFileReceive,
        fileName: share.fileName,
        cancel: CloseButton(
          onPressed: () => share.cancelShare(),
        ),
      );
    } else {
      return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            controller: sc,
            children: <Widget>[Text('An Error Occurred')],
          ));
    }
  }
}
