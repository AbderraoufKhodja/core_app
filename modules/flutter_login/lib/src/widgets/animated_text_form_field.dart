import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

enum TextFieldInertiaDirection {
  left,
  right,
}

Interval _getInternalInterval(
  double start,
  double end,
  double externalStart,
  double externalEnd, [
  Curve curve = Curves.linear,
]) {
  return Interval(
    start + (end - start) * externalStart,
    start + (end - start) * externalEnd,
    curve: curve,
  );
}

class AnimatedPhoneNumberFormField extends StatefulWidget {
  const AnimatedPhoneNumberFormField({
    Key? key,
    this.interval = const Interval(0.0, 1.0),
    required this.width,
    required this.onInputChanged,
    required this.initPhoneNumber,
    this.loadingController,
    this.inertiaController,
    this.inertiaDirection,
    this.enabled = true,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.onSaved,
    this.autocorrect = false,
    this.autofillHints,
  })  : assert((inertiaController == null && inertiaDirection == null) ||
            (inertiaController != null && inertiaDirection != null)),
        super(key: key);

  final void Function(PhoneNumber)? onInputChanged;
  final PhoneNumber initPhoneNumber;
  final Interval? interval;
  final AnimationController? loadingController;
  final AnimationController? inertiaController;
  final double width;
  final bool enabled;
  final bool autocorrect;
  final Iterable<String>? autofillHints;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final TextFieldInertiaDirection? inertiaDirection;

  @override
  State<AnimatedPhoneNumberFormField> createState() => _AnimatedPhoneNumberFormFieldState();
}

class _AnimatedPhoneNumberFormFieldState extends State<AnimatedPhoneNumberFormField> {
  late Animation<double> scaleAnimation;
  late Animation<double> sizeAnimation;
  late Animation<double> suffixIconOpacityAnimation;

  late Animation<double> fieldTranslateAnimation;
  late Animation<double> iconRotationAnimation;
  late Animation<double> iconTranslateAnimation;

  @override
  void initState() {
    super.initState();

    widget.inertiaController?.addStatusListener(handleAnimationStatus);

    final interval = widget.interval;
    final loadingController = widget.loadingController;

    if (loadingController != null) {
      scaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: loadingController,
        curve: _getInternalInterval(0, .2, interval!.begin, interval.end, Curves.easeOutBack),
      ));
      suffixIconOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: loadingController,
        curve: _getInternalInterval(.65, 1.0, interval.begin, interval.end),
      ));
      _updateSizeAnimation();
    }

    final inertiaController = widget.inertiaController;
    final inertiaDirection = widget.inertiaDirection;
    final sign = inertiaDirection == TextFieldInertiaDirection.right ? 1 : -1;

    if (inertiaController != null) {
      fieldTranslateAnimation = Tween<double>(
        begin: 0.0,
        end: sign * 15.0,
      ).animate(CurvedAnimation(
        parent: inertiaController,
        curve: const Interval(0, .5, curve: Curves.easeOut),
        reverseCurve: Curves.easeIn,
      ));
      iconRotationAnimation =
          Tween<double>(begin: 0.0, end: sign * pi / 12 /* ~15deg */).animate(CurvedAnimation(
        parent: inertiaController,
        curve: const Interval(.5, 1.0, curve: Curves.easeOut),
        reverseCurve: Curves.easeIn,
      ));
      iconTranslateAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(CurvedAnimation(
        parent: inertiaController,
        curve: const Interval(.5, 1.0, curve: Curves.easeOut),
        reverseCurve: Curves.easeIn,
      ));
    }
  }

  void _updateSizeAnimation() {
    final interval = widget.interval!;
    final loadingController = widget.loadingController!;

    sizeAnimation = Tween<double>(
      begin: 48.0,
      end: widget.width,
    ).animate(CurvedAnimation(
      parent: loadingController,
      curve: _getInternalInterval(.2, 1.0, interval.begin, interval.end, Curves.linearToEaseOut),
      reverseCurve: Curves.easeInExpo,
    ));
  }

  @override
  void didUpdateWidget(AnimatedPhoneNumberFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.width != widget.width) {
      _updateSizeAnimation();
    }
  }

  @override
  void dispose() {
    widget.inertiaController?.removeStatusListener(handleAnimationStatus);
    super.dispose();
  }

  void handleAnimationStatus(status) {
    if (status == AnimationStatus.completed) {
      widget.inertiaController?.reverse();
    }
  }

  Widget? _buildInertiaAnimation(Widget? child) {
    if (widget.inertiaController == null) {
      return child;
    }

    return AnimatedBuilder(
      animation: iconTranslateAnimation,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(iconTranslateAnimation.value)
          ..rotateZ(iconRotationAnimation.value),
        child: child,
      ),
      child: child,
    );
  }

  InputDecoration _getInputDecoration(ThemeData theme) {
    return InputDecoration(
      labelText: widget.labelText,
      prefixIcon: _buildInertiaAnimation(widget.prefixIcon),
      suffixIcon: _buildInertiaAnimation(widget.loadingController != null
          ? FadeTransition(
              opacity: suffixIconOpacityAnimation,
              child: widget.suffixIcon,
            )
          : widget.suffixIcon),
    );
  }

  late PhoneNumber initPhoneNumber = widget.initPhoneNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget textField = InternationalPhoneNumberInput(
      initialValue: widget.initPhoneNumber,
      onInputChanged: (phoneNumber) {
        initPhoneNumber = phoneNumber;
        widget.onInputChanged?.call(phoneNumber);
      },
      cursorColor: theme.primaryColor,
      textFieldController: widget.controller,
      focusNode: widget.focusNode,
      spaceBetweenSelectorAndTextField: 0,
      formatInput: false,
      inputDecoration: _getInputDecoration(theme),
      selectorConfig: const SelectorConfig(
        leadingPadding: 4,
        useEmoji: true,
        selectorType: PhoneInputSelectorType.DIALOG,
        showFlags: false,
        trailingSpace: false,
        setSelectorButtonAsPrefixIcon: true,
      ),
      keyboardType: TextInputType.phone,
      keyboardAction: widget.textInputAction,

      // obscureText: widget.obscureText,
      onFieldSubmitted: widget.onFieldSubmitted,
      // onSaved: widget.onSaved,
      validator: widget.validator,
      isEnabled: widget.enabled,
      // enabled: widget.enabled,
      // autocorrect: widget.autocorrect,
      autofillHints: widget.autofillHints,
    );

    if (widget.loadingController != null) {
      textField = ScaleTransition(
        scale: scaleAnimation,
        child: AnimatedBuilder(
          animation: sizeAnimation,
          builder: (context, child) => ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: sizeAnimation.value),
            child: child,
          ),
          child: textField,
        ),
      );
    }

    if (widget.inertiaController != null) {
      textField = AnimatedBuilder(
        animation: fieldTranslateAnimation,
        builder: (context, child) => Transform.translate(
          offset: Offset(fieldTranslateAnimation.value, 0),
          child: child,
        ),
        child: textField,
      );
    }

    return textField;
  }
}

class AnimatedTextFormField extends StatefulWidget {
  const AnimatedTextFormField({
    Key? key,
    this.interval = const Interval(0.0, 1.0),
    required this.width,
    this.loadingController,
    this.inertiaController,
    this.inertiaDirection,
    this.enabled = true,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.onSaved,
    this.autocorrect = false,
    this.autofillHints,
  })  : assert((inertiaController == null && inertiaDirection == null) ||
            (inertiaController != null && inertiaDirection != null)),
        super(key: key);

  final Interval? interval;
  final AnimationController? loadingController;
  final AnimationController? inertiaController;
  final double width;
  final bool enabled;
  final bool autocorrect;
  final Iterable<String>? autofillHints;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final TextFieldInertiaDirection? inertiaDirection;

  @override
  State<AnimatedTextFormField> createState() => _AnimatedTextFormFieldState();
}

class _AnimatedTextFormFieldState extends State<AnimatedTextFormField> {
  late Animation<double> scaleAnimation;
  late Animation<double> sizeAnimation;
  late Animation<double> suffixIconOpacityAnimation;

  late Animation<double> fieldTranslateAnimation;
  late Animation<double> iconRotationAnimation;
  late Animation<double> iconTranslateAnimation;

  @override
  void initState() {
    super.initState();

    widget.inertiaController?.addStatusListener(handleAnimationStatus);

    final interval = widget.interval;
    final loadingController = widget.loadingController;

    if (loadingController != null) {
      scaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: loadingController,
        curve: _getInternalInterval(0, .2, interval!.begin, interval.end, Curves.easeOutBack),
      ));
      suffixIconOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: loadingController,
        curve: _getInternalInterval(.65, 1.0, interval.begin, interval.end),
      ));
      _updateSizeAnimation();
    }

    final inertiaController = widget.inertiaController;
    final inertiaDirection = widget.inertiaDirection;
    final sign = inertiaDirection == TextFieldInertiaDirection.right ? 1 : -1;

    if (inertiaController != null) {
      fieldTranslateAnimation = Tween<double>(
        begin: 0.0,
        end: sign * 15.0,
      ).animate(CurvedAnimation(
        parent: inertiaController,
        curve: const Interval(0, .5, curve: Curves.easeOut),
        reverseCurve: Curves.easeIn,
      ));
      iconRotationAnimation =
          Tween<double>(begin: 0.0, end: sign * pi / 12 /* ~15deg */).animate(CurvedAnimation(
        parent: inertiaController,
        curve: const Interval(.5, 1.0, curve: Curves.easeOut),
        reverseCurve: Curves.easeIn,
      ));
      iconTranslateAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(CurvedAnimation(
        parent: inertiaController,
        curve: const Interval(.5, 1.0, curve: Curves.easeOut),
        reverseCurve: Curves.easeIn,
      ));
    }
  }

  void _updateSizeAnimation() {
    final interval = widget.interval!;
    final loadingController = widget.loadingController!;

    sizeAnimation = Tween<double>(
      begin: 48.0,
      end: widget.width,
    ).animate(CurvedAnimation(
      parent: loadingController,
      curve: _getInternalInterval(.2, 1.0, interval.begin, interval.end, Curves.linearToEaseOut),
      reverseCurve: Curves.easeInExpo,
    ));
  }

  @override
  void didUpdateWidget(AnimatedTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.width != widget.width) {
      _updateSizeAnimation();
    }
  }

  @override
  void dispose() {
    widget.inertiaController?.removeStatusListener(handleAnimationStatus);
    super.dispose();
  }

  void handleAnimationStatus(status) {
    if (status == AnimationStatus.completed) {
      widget.inertiaController?.reverse();
    }
  }

  Widget? _buildInertiaAnimation(Widget? child) {
    if (widget.inertiaController == null) {
      return child;
    }

    return AnimatedBuilder(
      animation: iconTranslateAnimation,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(iconTranslateAnimation.value)
          ..rotateZ(iconRotationAnimation.value),
        child: child,
      ),
      child: child,
    );
  }

  InputDecoration _getInputDecoration(ThemeData theme) {
    return InputDecoration(
      labelText: widget.labelText,
      contentPadding: const EdgeInsets.only(left: 20.0),
      prefixIcon: _buildInertiaAnimation(widget.prefixIcon),
      suffixIcon: _buildInertiaAnimation(widget.loadingController != null
          ? FadeTransition(
              opacity: suffixIconOpacityAnimation,
              child: widget.suffixIcon,
            )
          : widget.suffixIcon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget textField = TextFormField(
      cursorColor: theme.primaryColor,
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: _getInputDecoration(theme),
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      validator: widget.validator,
      enabled: widget.enabled,
      autocorrect: widget.autocorrect,
      autofillHints: widget.autofillHints,
    );

    if (widget.loadingController != null) {
      textField = ScaleTransition(
        scale: scaleAnimation,
        child: AnimatedBuilder(
          animation: sizeAnimation,
          builder: (context, child) => ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: sizeAnimation.value),
            child: child,
          ),
          child: textField,
        ),
      );
    }

    if (widget.inertiaController != null) {
      textField = AnimatedBuilder(
        animation: fieldTranslateAnimation,
        builder: (context, child) => Transform.translate(
          offset: Offset(fieldTranslateAnimation.value, 0),
          child: child,
        ),
        child: textField,
      );
    }

    return textField;
  }
}

class AnimatedPasswordTextFormField extends StatefulWidget {
  const AnimatedPasswordTextFormField({
    Key? key,
    this.interval = const Interval(0.0, 1.0),
    required this.animatedWidth,
    required this.sendOTPWidget,
    this.loadingController,
    this.inertiaController,
    this.inertiaDirection,
    this.enabled = true,
    this.labelText,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.onSaved,
    this.autofillHints,
  })  : assert((inertiaController == null && inertiaDirection == null) ||
            (inertiaController != null && inertiaDirection != null)),
        super(key: key);

  final Widget? sendOTPWidget;
  final Interval? interval;
  final AnimationController? loadingController;
  final AnimationController? inertiaController;
  final double animatedWidth;
  final bool enabled;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final TextFieldInertiaDirection? inertiaDirection;
  final Iterable<String>? autofillHints;

  @override
  State<AnimatedPasswordTextFormField> createState() => _AnimatedPasswordTextFormFieldState();
}

class _AnimatedPasswordTextFormFieldState extends State<AnimatedPasswordTextFormField> {
  final _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedTextFormField(
      interval: widget.interval,
      loadingController: widget.loadingController,
      inertiaController: widget.inertiaController,
      width: widget.animatedWidth,
      enabled: widget.enabled,
      autofillHints: widget.autofillHints,
      labelText: widget.labelText,
      suffixIcon: widget.sendOTPWidget,
      obscureText: false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      inertiaDirection: widget.inertiaDirection,
    );
  }
}
