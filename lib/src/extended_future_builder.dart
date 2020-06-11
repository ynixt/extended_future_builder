import 'package:flutter/material.dart';

typedef FutureResponseBuilder<T> = Future<T> Function();

typedef FutureBuilderSuccess<T> = Widget Function(
    BuildContext buildContext, T data);
typedef FutureBuilderError = Widget Function(
    BuildContext buildContext, dynamic error);
typedef FutureBuilderEmpty = Widget Function(BuildContext buildContext);

typedef FutureBuilderFtrStarted<T> = void Function();
typedef FutureBuilderFtrThen<T> = void Function(T data);
typedef FutureBuilderFtrCatch = void Function(dynamic error);

/// A FutureBuilder with some cool options
/// ```dart
/// ExtendedFutureBuilder<User>(
///         futureResponseBuilder: () => service.getUser(userId),
///         ftrStarted: () {
///           title = 'Loading...';
///         },
///         ftrThen: (user) {
///           setState(() {
///             title = 'Hi ${user.name}';
///           });
///         },
///         ftrCatch: (err) {
///           setState(() {
///             title = 'Error :(';
///           });
///         },
///         errorBuilder: (BuildContext context, error) {
///           return Center(
///             child: Text('An error has occurred. Tap to try again.'),
///           );
///         },
///         successBuilder: (BuildContext context, User user) {
///           return Text('Good morning ${user.name}');
///         },
///       ),
/// ```
class ExtendedFutureBuilder<T> extends StatefulWidget {
  /// Builder responsible for return the future. Used on initState and on retry.
  final FutureResponseBuilder<T> futureResponseBuilder;

  /// Builder responsible for return the widget when Future was geted successful and have any data.
  final FutureBuilderSuccess<T> successBuilder;

  /// Builder responsible for return the widget while Future aren't ready.
  final FutureBuilderEmpty loadingBuilder;

  /// Builder responsible for return the widget when Future was geted successful and have no data.
  final FutureBuilderEmpty emptyBuilder;

  /// Builder responsible for return the widget when Future was geted unsuccessful.
  final FutureBuilderError errorBuilder;

  /// Callback for the moment of creation of Future.
  final FutureBuilderFtrStarted ftrStarted;

  /// Callback for Future success.
  final FutureBuilderFtrThen<T> ftrThen;

  /// Callback for Future error.
  final FutureBuilderFtrCatch ftrCatch;

  /// Indicates if user can tap on widget of error for build a new Future and try again.
  final bool allowRetry;

  static Widget _defaultLoadingBuilder(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  ExtendedFutureBuilder({
    Key key,
    @required this.futureResponseBuilder,
    @required this.successBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.loadingBuilder = _defaultLoadingBuilder,
    this.ftrStarted,
    this.ftrThen,
    this.ftrCatch,
    this.allowRetry = true,
  }) : super(key: key);

  @override
  _ExtendedFutureBuilderState<T> createState() =>
      _ExtendedFutureBuilderState<T>();
}

class _ExtendedFutureBuilderState<T> extends State<ExtendedFutureBuilder<T>> {
  Future<T> _future;
  GlobalKey _globalKey;

  @override
  void initState() {
    _future = this.widget.futureResponseBuilder();
    _registerCallbacks(_future);
    _globalKey = GlobalKey();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      key: _globalKey,
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError && this.widget.errorBuilder != null) {
          if (this.widget.allowRetry) {
            return InkWell(
              child: this.widget.errorBuilder(context, snapshot.error),
              onTap: () {
                setState(() {
                  _future = this.widget.futureResponseBuilder();
                  _registerCallbacks(_future);
                  _globalKey = GlobalKey();
                });
              },
            );
          } else {
            return this.widget.errorBuilder(context, snapshot.error);
          }
        }

        if (snapshot.hasData) {
          return this.widget.successBuilder(context, snapshot.data);
        }

        if (!snapshot.hasData) {
          if (snapshot.connectionState != ConnectionState.done) {
            return this.widget.loadingBuilder(context);
          }

          if (this.widget.emptyBuilder != null) {
            return this.widget.emptyBuilder(context);
          }
        }

        return Container();
      },
    );
  }

  void _registerCallbacks(Future future) {
    if (this.widget.ftrStarted != null) {
      this.widget.ftrStarted();
    }

    if (this.widget.ftrThen != null) {
      future.then((value) {
        if (this.widget.ftrThen != null && mounted) {
          this.widget.ftrThen(value);
        }
      });
    }

    if (this.widget.ftrCatch != null) {
      future.catchError((err) {
        if (this.widget.ftrCatch != null && mounted) {
          this.widget.ftrCatch(err);
        }
      });
    }
  }
}