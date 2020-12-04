///
/// fast_text_field.dart
/// fast_app
/// Created by qiuguian on 2019/10/21.
/// Copyright © 2019 fastapp. All rights reserved.
///
/// website: http://www.fastapp.top
///

part of fast_app_ui;

enum FastTextFieldType {
  normal,
  titleSingle,
  readonly,
}

class FastTextField extends StatefulWidget {
  final String name;
  final String placeholder;
  final String labelValue;
  final TextEditingController controller;
  final Widget prefix;
  final Widget suffix;
  final FastTextFieldType type;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final TextStyle style;
  final TextStyle hintStyle;
  final bool obscureText;
  final EdgeInsetsGeometry padding;
  final FormFieldValidator<String> validator;
  final bool autovalidate;
  final Color borderColor;
  final Color backgroundColor;
  final bool enable;
  List<TextInputFormatter> inputFormatters;
  final double titleWidth;
  final double spacing;
  final int maxLine;

  FastTextField({
    this.name,
    this.placeholder,
    this.controller,
    this.prefix,
    this.suffix,
    this.type = FastTextFieldType.titleSingle,
    this.onChanged,
    this.keyboardType,
    this.style = const TextStyle(color: Color(0xff030303)),
    this.hintStyle = const TextStyle(color: Color(0xffDFE0EB)),
    this.obscureText = false,
    this.labelValue,
    this.padding = EdgeInsets.zero,
    this.validator,
    this.autovalidate = false,
    this.borderColor = const Color(0xffEBEBEB),
    this.backgroundColor = Colors.transparent,
    this.inputFormatters = const <TextInputFormatter>[],
    this.enable = true,
    this.titleWidth = 100.0,
    this.spacing = 10,
    this.maxLine = 1,
  });

  @override
  _FastTextFieldState createState() => _FastTextFieldState();
}

class _FastTextFieldState extends State<FastTextField> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(
          top: widget.type == FastTextFieldType.titleSingle ? 10.0 : 0),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border(
          bottom: new BorderSide(
              color: widget.type == FastTextFieldType.readonly
                  ? Colors.transparent
                  : widget.borderColor,
              width: 0.5),
        ),
      ),
      child: widget.type == FastTextFieldType.titleSingle
          ? new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.name != null
              ? new Text('${widget.name}',
              style: widget.style ??
                  TextStyle(
                      color: Color(0xff343243),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500))
              : new Container(),
          new Row(
            children: <Widget>[
              widget.prefix ?? new Container(),
              new Container(width: widget.spacing),
              new Expanded(
                child: new TextFormField(
                  controller: widget.controller,
                  keyboardType: widget.keyboardType ?? null,
                  style: widget.style,
                  maxLines: widget.maxLine,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: widget.hintStyle ?? null,
                    hintMaxLines: 2,
                    border: InputBorder.none,
                  ),
                  onChanged: widget.onChanged ?? (str) {},
                  obscureText: widget.obscureText,
                  validator: widget.validator,
                  autovalidate: widget.autovalidate,
                  inputFormatters: widget.inputFormatters,
                  enabled: widget.enable,
                ),
              ),
              widget.suffix ?? new Container(),
            ],
          ),
        ],
      )
          : new Container(
        height: 55.0,
        child: new Row(
          children: <Widget>[
            widget.name != null
                ? new Container(
              width: widget.titleWidth,
              child: new Text(
                  '${widget.name}',
                  style: widget.style ??
                      TextStyle(
                          color: Color(0xff343243),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500)
              ),
            )
                : new Container(),
            new Expanded(
              child: new TextFormField(
                controller: widget.controller,
                keyboardType: widget.keyboardType ?? null,
                style: widget.style,
                enabled: widget.type != FastTextFieldType.readonly &&
                    widget.enable,
                maxLines: widget.maxLine,
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle: TextStyle(
                      color: Color(0xffDFE0EB), fontSize: 15.0),
                  border: InputBorder.none,
                ),
                onChanged: widget.onChanged ?? (str) {},
                obscureText: widget.obscureText,
                validator: widget.validator,
                autovalidate: widget.autovalidate,
                inputFormatters: widget.inputFormatters,
              ),
            ),
            widget.suffix ?? new Container(),
          ],
        ),
      ),
    );
  }
}

class FastKeyboardControl extends StatelessWidget {
  final Widget child;

  FastKeyboardControl({this.child});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: child,
    );
  }
}
