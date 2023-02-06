import 'package:flutter/material.dart';

ColorFilter enablefilter =
    new ColorFilter.mode(Colors.transparent, BlendMode.dst);
ColorFilter invisiblefilter =
    new ColorFilter.mode(Colors.transparent, BlendMode.dstATop);
ColorFilter disabledfilter =
    new ColorFilter.mode(Colors.grey, BlendMode.multiply);

class CustomButton extends StatefulWidget {
  final Widget child;
  final Function onclick;
  final bool flatbtn;
  final bool loadingenabled;
  final Color btncolor;
  const CustomButton(
      {@required this.child,
      @required this.onclick,
      this.btncolor = Colors.green,
      this.flatbtn = false,
      this.loadingenabled = false});
  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isenabled = true;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    if (widget.flatbtn) {
      //For Flat Button...........................................................................
      return GestureDetector(
        onTap: () async {
          if (isenabled) {
            setState(() => isenabled = false);
            try {
              await widget.onclick();
            } catch (e) {
              print(e);
              setState(() => isenabled = true);
            } finally {
              setState(() => isenabled = true);
            }
          }
        },
        child: ColorFiltered(colorFilter: enablefilter, child: widget.child),
      );
    } else {
      if (widget.loadingenabled) {
        //.................................................for loading btn
        return GestureDetector(
          onTap: () async {
            if (!isloading) {
              setState(() => isloading = true);
              try {
                await widget.onclick();
                await Future.delayed(Duration(seconds: 1));
              } catch (e) {
                print(e);
              } finally {
                if (mounted) setState(() => isloading = false);
              }
            }
          },
          child: ColorFiltered(
              colorFilter: enablefilter,
              child: isloading
                  ? Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(15),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: widget.btncolor,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      ),
                    )
                  : widget.child),
        );
      } else {
        return GestureDetector(
          onTap: () async {
            if (isenabled) {
              setState(() => isenabled = false);
              try {
                await widget.onclick();
              } catch (e) {
                print(e);
                setState(() => isenabled = true);
              } finally {
                setState(() => isenabled = true);
              }
            }
          },
          child: ColorFiltered(
              colorFilter: isenabled ? enablefilter : disabledfilter,
              child: widget.child),
        );
      }
    }
  }
}
