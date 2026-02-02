# Live Activity Button Bug Demo

**Test Instructions**

1. Set a valid team and bundle identifier
2. Run the app
3. Request push token and copy
4. Use APNS console to send a live activity push type with the following payload:
```json
{
    "aps": {
        "attributes": {
            "name": "Hello"
        },
        "attributes-type": "LiveActivityAttributes",
        "event": "start",
        "content-state": {
            "items": [
                {
                    "emoji": "😀"
                },
                {
                    "emoji": "😡"
                },
                {
                    "emoji": "😈"
                }
            ]
        },
        "timestamp": 0,
        "alert": {
            "title": "Test",
            "body": "Hello World"
        }
    }
}
```
5. Ensure button on the live activity cycle the emoji
6. Be sure to allow live activities from the lock screen and find "PUSH TOKEN" in Xcode log
7. Use the push token to send a live activity push type in the console with this payload:
```json
{
    "aps": {
        "event": "update",
        "content-state": {
            "items": [
                {
                    "emoji": "😀"
                },
                {
                    "emoji": "😱"
                },
                {
                    "emoji": "😈"
                }
            ]
        },
        "timestamp": 1770051103239,
        "alert": {
            "title": "Test",
            "body": "Hello World"
        }
    }
}
```
8. Note the buttons in the live activity no longer cycle the emoji
