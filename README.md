# Extended Future Builder

A FutureBuilder with some cool options

- Tap to retry the future on case of error
- builders for future loading, error and success

## Why

After using Future Builder a lot for http requests, I realized that it was possible to simplify the necessary work a little. Thus was born this library, where there is a separation of the builder functions in: success, loading, emptiness and error. It is also possible, in case of Future error, to click on the widget to try to load Future again, which is very useful in http requests that may have failed due to user's Internet related problems.

## Parameters

| parameter             | description                                                                                   | default                                     |
|-----------------------|-----------------------------------------------------------------------------------------------|---------------------------------------------|
| futureResponseBuilder | Builder responsible for return the future. Used on initState and on retry.                    | required                                    |
| successBuilder        | Builder responsible for return the widget when Future was geted successful and have any data. | required                                    |
| loadingBuilder        | Builder responsible for return the widget while Future aren't ready.                          | Center(child: CircularProgressIndicator()); |
| emptyBuilder          | Builder responsible for return the widget when Future was geted successful and have no data.  |                                             |
| errorBuilder          | Builder responsible for return the widget when Future was geted unsuccessful.                 |                                             |
| ftrStarted            | Callback for the moment of creation of Future.                                                |                                             |
| ftrThen               | Callback for Future success.                                                                  |                                             |
| ftrCatch              | Callback for Future error.                                                                    |                                             |
| allowRetry            | Indicates if user can tap on widget of error for build a new Future and try again.            | true                                        |

## Example

```dart
ExtendedFutureBuilder<User>(
        futureResponseBuilder: () => service.getUser(userId),
        ftrStarted: () {
          title = 'Loading...';
        },
        ftrThen: (user) {
          setState(() {
            title = 'Hi ${user.name}';
          });
        },
        ftrCatch: (err) {
          setState(() {
            title = 'Error :(';
          });
        },
        errorBuilder: (BuildContext context, error) {
          return Center(
            child: Text('An error has occurred. Tap to try again.'),
          );
        },
        successBuilder: (BuildContext context, User user) {
          return Text('Good morning ${user.name}');
        },
      ),
```
