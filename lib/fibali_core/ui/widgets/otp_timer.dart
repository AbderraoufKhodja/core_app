import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';

class OtpTimerButton extends StatefulWidget {
  /// Called when the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  /// The button text
  final String text;

  /// the loading indicator
  final ProgressIndicator? loadingIndicator;

  /// Length of the timer in second
  final int duration;

  /// Manual control button state [ButtonState]
  ///
  /// When controller is not null auto start timer is disabled on pressed button
  final OtpTimerButtonController? controller;

  /// Height of the button
  final double? height;

  /// Background color of the button
  final Color? backgroundColor;

  /// Color of the text
  final Color? textColor;

  /// Color of the loading indicator
  final Color? loadingIndicatorColor;

  /// Button type
  /// elevated_button, text_button, outlined_button [ButtonType]
  final ButtonType buttonType;

  /// The radius of the button border
  final double? radius;

  const OtpTimerButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.loadingIndicator,
      required this.duration,
      this.controller,
      this.height,
      this.backgroundColor,
      this.textColor,
      this.loadingIndicatorColor,
      this.buttonType = ButtonType.elevated_button,
      this.radius})
      : super(key: key);

  @override
  _OtpTimerButtonState createState() => _OtpTimerButtonState();
}

class _OtpTimerButtonState extends State<OtpTimerButton> {
  Timer? _timer;
  int _counter = 0;
  ButtonState _state = ButtonState.enable_button;

  @override
  void initState() {
    super.initState();
    widget.controller?._addListeners(_startTimer, _loading, _enableButton);
  }

  _startTimer() {
    _timer?.cancel();
    _state = ButtonState.timer;
    _counter = widget.duration;

    setState(() {});

    _timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (_counter == 0) {
          _state = ButtonState.enable_button;
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _counter--;
          });
        }
      },
    );
  }

  _loading() {
    _state = ButtonState.loading;
    setState(() {});
  }

  _enableButton() {
    _state = ButtonState.enable_button;
    setState(() {});
  }

  Widget _childBuilder() {
    final text = Text(widget.text);
    switch (_state) {
      case ButtonState.enable_button:
        return Text(
          widget.text,
          style: TextStyle(color: Theme.of(context).primaryColor),
        );
      case ButtonState.loading:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            text,
            SizedBox(width: 10),
            SizedBox(
              width: 20,
              height: 20,
              child: widget.loadingIndicator ??
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: widget.loadingIndicatorColor,
                  ),
            ),
          ],
        );
      case ButtonState.timer:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            text,
            SizedBox(width: 10),
            Text(
              '$_counter',
              style: text.style,
            ),
          ],
        );
    }
  }

  _roundedRectangleBorder() {
    if (widget.radius != null) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius!),
      );
    } else {
      return null;
    }
  }

  _onPressedButton() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }

    // if (widget.controller == null) {
    //   _startTimer();
    // }
  }

  _buildButton() {
    switch (widget.buttonType) {
      case ButtonType.text:
        return TextButton(
          onPressed: _state == ButtonState.enable_button ? _onPressedButton : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: widget.textColor,
            backgroundColor: widget.backgroundColor,
            shape: _roundedRectangleBorder(),
          ),
          child: _childBuilder(),
        );
      case ButtonType.elevated_button:
        return ElevatedButton(
          onPressed: _state == ButtonState.enable_button ? _onPressedButton : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: widget.textColor,
            backgroundColor: widget.backgroundColor,
            shape: _roundedRectangleBorder(),
          ),
          child: _childBuilder(),
        );
      case ButtonType.text_button:
        return TextButton(
          onPressed: _state == ButtonState.enable_button ? _onPressedButton : null,
          style: TextButton.styleFrom(
            foregroundColor: widget.backgroundColor,
            shape: _roundedRectangleBorder(),
            splashFactory: NoSplash.splashFactory,
          ),
          child: _childBuilder(),
        );
      case ButtonType.outlined_button:
        return OutlinedButton(
          onPressed: _state == ButtonState.enable_button ? _onPressedButton : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: widget.backgroundColor,
            shape: _roundedRectangleBorder(),
          ),
          child: _childBuilder(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _timerCubit = BlocProvider.of<TimerCubit>(context);
    return BlocListener<TimerCubit, TimerEvent>(
      listener: (context, state) {
        if (state is TimerStartTimer) _startTimer();
        if (state is TimerLoading) _loading();
        if (state is TimerEnableButton) _enableButton();
      },
      child: SizedBox(
        height: widget.height,
        child: _buildButton(),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class OtpTimerButtonController {
  late VoidCallback _startTimerListener;
  late VoidCallback _loadingListener;
  late VoidCallback _enableButtonListener;

  _addListeners(startTimerListener, loadingListener, enableButtonListener) {
    this._startTimerListener = startTimerListener;
    this._loadingListener = loadingListener;
    this._enableButtonListener = enableButtonListener;
  }

  /// Notify listener to start the timer
  startTimer() {
    _startTimerListener();
  }

  /// Notify listener to show loading
  loading() {
    _loadingListener();
  }

  /// Notify listener to enable button
  enableButton() {
    _enableButtonListener();
  }
}

class TimerCubit extends Cubit<TimerEvent> {
  TimerCubit(super.initialState);

  startTimer() {
    emit(TimerStartTimer());
  }

  enableButton() {
    emit(TimerEnableButton());
  }

  loading() {
    emit(TimerLoading());
  }
}

enum ButtonState { enable_button, loading, timer }

abstract class TimerEvent {}

class TimerInit extends TimerEvent {}

class TimerLoading extends TimerEvent {}

class TimerStartTimer extends TimerEvent {}

class TimerEnableButton extends TimerEvent {}

enum ButtonType { text, elevated_button, text_button, outlined_button }
