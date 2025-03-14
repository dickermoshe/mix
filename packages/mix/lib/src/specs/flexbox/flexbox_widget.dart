// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';

import '../../core/factory/mix_provider.dart';
import '../../core/styled_widget.dart';
import '../../modifiers/internal/render_widget_modifier.dart';
import '../box/box_spec.dart';
import '../flex/flex_spec.dart';
import 'flexbox_spec.dart';

/// A flex container widget with integrated `Style` for enhanced styling.
///
/// `FlexBox` combines the features of `StyledContainer` and `StyledFlex`, offering
/// a powerful tool for creating flexible layouts with advanced styling capabilities
/// through `Style`. It's perfect for designing complex layouts that require both
/// container and flex properties with uniform styling.
///
/// The `direction` parameter sets the layout's orientation, while the `Style`
/// integration simplifies the process of applying consistent styles to all elements.
///
/// Example Usage:
/// ```dart
/// FlexBox(
///   direction: Axis.horizontal,
///   style: yourStyle,
///   children: [Widget1(), Widget2()],
/// );
/// ```
class FlexBox extends StyledWidget {
  const FlexBox({
    super.style,
    super.key,
    super.inherit,
    required this.direction,
    required this.children,
    super.orderOfModifiers = const [],
  });

  final List<Widget> children;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    // TODO: the support for FlexBoxSpec using BoxSpec and FlexSpec is a temporary
    // solution to not break the existing API. it should be implemented using only
    // FlexBoxSpec in the next major version.
    return withMix(context, (context) {
      final mixData = Mix.of(context);

      final spec =
          mixData.attributeOf<FlexBoxSpecAttribute>()?.resolve(mixData);

      final boxSpec = spec?.box ?? BoxSpec.of(context);
      final flexSpec = spec?.flex ?? FlexSpec.of(context);

      final newSpec = FlexBoxSpec(
        animated: spec?.animated,
        modifiers: spec?.modifiers,
        box: boxSpec,
        flex: flexSpec,
      );

      return newSpec(direction: direction, children: children);
    });
  }
}

class FlexBoxSpecWidget extends StatelessWidget {
  const FlexBoxSpecWidget({
    super.key,
    this.spec,
    required this.children,
    required this.direction,
    this.orderOfModifiers = const [],
  });

  final List<Widget> children;
  final Axis direction;
  final FlexBoxSpec? spec;
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context) {
    final spec = this.spec ?? const FlexBoxSpec();

    // TODO: Convert to a BoxSpecWidget and a FlexSpecWidget in the next major version.
    // it should be implemented following the same pattern as the others SpecWidgets.
    // This code must be like this to keep the existing animation API working.
    return RenderSpecModifiers(
      spec: spec,
      orderOfModifiers: orderOfModifiers,
      child: spec.box(
        orderOfModifiers: orderOfModifiers,
        child: spec.flex(direction: direction, children: children),
      ),
    );
  }
}

class AnimatedFlexBoxSpecWidget extends ImplicitlyAnimatedWidget {
  const AnimatedFlexBoxSpecWidget({
    super.key,
    required this.spec,
    required this.children,
    required this.direction,
    this.orderOfModifiers = const [],
    super.curve,
    required super.duration,
    super.onEnd,
  });

  final FlexBoxSpec spec;
  final List<Widget> children;
  final Axis direction;
  final List<Type> orderOfModifiers;

  @override
  AnimatedFlexBoxSpecWidgetState createState() =>
      AnimatedFlexBoxSpecWidgetState();
}

class AnimatedFlexBoxSpecWidgetState
    extends AnimatedWidgetBaseState<AnimatedFlexBoxSpecWidget> {
  FlexBoxSpecTween? _specTween;

  @override
  // ignore: avoid-dynamic
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _specTween = visitor(
      _specTween,
      widget.spec,
      // ignore: avoid-dynamic
      (dynamic value) => FlexBoxSpecTween(begin: value as FlexBoxSpec),
    ) as FlexBoxSpecTween?;
  }

  @override
  Widget build(BuildContext context) {
    return FlexBoxSpecWidget(
      spec: _specTween?.evaluate(animation),
      direction: widget.direction,
      orderOfModifiers: widget.orderOfModifiers,
      children: widget.children,
    );
  }
}

/// A horizontal flex container with `Style` for easy and consistent styling.
///
/// `HBox` is a specialized `FlexBox` designed for horizontal layouts, simplifying
/// the process of applying horizontal alignment with advanced styling via `Style`.
/// It's an efficient way to achieve consistent styling in horizontal arrangements.
///
/// Inherits all functionalities of `FlexBox`, optimized for horizontal layouts.
///
/// Example Usage:
/// ```dart
/// HBox(
///   style: yourStyle,
///   children: [Widget1(), Widget2()],
/// );
/// ```
class HBox extends FlexBox {
  const HBox({
    super.style,
    super.key,
    super.inherit,
    super.children = const <Widget>[],
  }) : super(direction: Axis.horizontal);
}

/// A vertical flex container that uses `Style` for streamlined styling.
///
/// `VBox` is a vertical counterpart to `HBox`, utilizing `Style` for efficient
/// and consistent styling in vertical layouts. It offers an easy way to manage
/// vertical alignment and styling in a cohesive manner.
///
/// Inherits the comprehensive styling and layout capabilities of `FlexBox`, tailored
/// for vertical orientations.
///
/// Example Usage:
/// ```dart
/// VBox(
///   style: yourStyle,
///   children: [Widget1(), Widget2()],
/// );
/// ```
class VBox extends FlexBox {
  const VBox({
    super.style,
    super.key,
    super.inherit,
    super.children = const <Widget>[],
  }) : super(direction: Axis.vertical);
}
