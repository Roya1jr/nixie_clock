// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('ss').format(_dateTime);
    final firstHourDigit = hour.toString().substring(0, 1);
    final secondHourDigit = hour.toString().substring(1, 2);
    final firstMinuteDigit = minute.toString().substring(0, 1);
    final secondMinuteDigit = minute.toString().substring(1, 2);
    final firstSecondDigit = second.toString().substring(0, 1);
    final secondSecondDigit = second.toString().substring(1, 2);

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Image.asset(
                          'assets/images/dark_$firstHourDigit.jpg')),
                  Expanded(
                      child: Image.asset(
                          'assets/images/dark_$secondHourDigit.jpg')),
                ],
              ),
              flex: 5,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Image.asset(
                          'assets/images/dark_$firstSecondDigit.jpg')),
                  Expanded(
                      child: Image.asset(
                          'assets/images/dark_$secondSecondDigit.jpg')),
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Image.asset(
                          'assets/images/dark_$firstMinuteDigit.jpg')),
                  Expanded(
                      child: Image.asset(
                          'assets/images/dark_$secondMinuteDigit.jpg')),
                ],
              ),
              flex: 5,
            ),
          ],
        ),
      ),
    );
  }
}
