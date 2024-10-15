part of 'menu_item.dart';

class FortalezaMenuItemStyle extends MenuItemStyle {
  const FortalezaMenuItemStyle();

  @override
  Style makeStyle(SpecConfiguration<MenuItemSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);
    final textFlex = $.textFlex.chain..gap.$space(1);

    final mainFlex = $.mainFlex.chain..gap.$space(3);
    final title = $.title.chain
      ..style.$text(2)
      ..style.color.resetDirectives()
      ..style.color.$neutral(12);

    final subtitle = $.subtitle.chain
      ..style.$text(1)
      ..style.color.resetDirectives()
      ..style.color.$neutral(9);

    final container = $.container.chain
      ..padding.all.$space(3)
      ..padding.right.$space(4)
      ..borderRadius.all.$radius(2);

    final icon = $.icon.color.$neutral(11);

    final hovered = $.container.color.$accent(2);

    final disabled = $.chain
      ..title.style.color.$neutral(9)
      ..subtitle.style.color.$neutral(8)
      ..icon.color.$neutral(8);

    return Style.create([
      baseStyle(),
      textFlex,
      mainFlex,
      title,
      subtitle,
      container,
      icon,
      spec.on.hover(hovered),
      spec.on.disabled(disabled),
    ]).animate(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }
}
