---
title: Integrate LINE Login with your app
description: 
sidebar: android-sidebar
permalink: android-integrate-line-login.html
folder: android-sdk
---

This guide explains how to implement [LINE Login][] by integrating the LINE SDK for Android with your existing Android app. If you would like to see what LINE Login can do, go to [Try LINE Login][] to try the LINE Login Android starter application.

## Before you begin

Make sure you have completed the following before you begin.

- [Created a Channel for your Android app][create channel]
- Set the Android package name and Android package signature in the console
- Have `minSdkVersion` set to 15 or higher (Android 4.0.3 or higher)

Note: Do not use resource IDs that start with `linesdk_` as this may cause conflicts with the resources in the SDK.

## Downloading the SDK

To begin integrating the SDK with your existing Android app, download the LINE SDK for Android from the [download page][download page]. Note: We recommend using the latest version of the SDK as the previous versions of the SDK have been deprecated.

1. Click the link of the SDK file and save to any directory.

## Installing the SDK

To install the LINE SDK for Android, import the required libraries to your project and configure the Android manifest file of your project by following the steps below.

### Import the library into your project

1. Copy the `.aar` file to your project's `libs` folder.
2. Add the `libs` folder as a repository to your top-level `build.gradle` file.  

        ```
        allprojects {
            repositories {
                ...
                flatDir {
                    dirs 'libs'
                }
            ...
            }
        }
        ```

  3. Add the `compile` dependency to the SDK in your module-level `build.gradle` file.  

        ```java
        dependencies {
        ...
        compile(name:'line-sdk-4.0.5', ext:'aar')
        ...
        } 
        ```

### Add required Android support libraries

The following Android support libraries are required for the LINE SDK.

- v7 appcompat library
- Custom Tabs

Add the support libraries to the `dependencies` section of your module-level `build.gradle` file. The following is an example of the support libraries for API level 25. Note that you should use versions of the support libraries for your corresponding Android API level.

```java
dependencies {
	...
    compile 'com.android.support:appcompat-v7:25.4.0'
    compile 'com.android.support:customtabs:25.4.0'
	...
}
```

## Set Android manifest file settings

To identify that your app requires Internet access, add the `INTERNET` permission to your `AndroidManifest.xml` file.

```java
<uses-permission android:name="android.permission.INTERNET" />
```

Note: Make sure the launch mode of the activity that is making the login call is not set to `singleInstance` as that may prevent the activity from receiving the `onActivityResult` callback.

## Adding the LINE Login button

To let the user log in to your Android app, you can create a LINE-branded login button to take the user through the authentication and authorization process.

### Download and add the images to your project

The LINE Login button image set includes images for iOS, Android and desktop applications. The image set for Android includes images for multiple screen densities and button states. In this guide, we’ll use the “base” and “pressed” login button images in the Android folder.

1. Download and extract the [LINE Login button images][].
2. Add the “base” and “pressed” login button images to a `drawable` folder for each screen density.

#### Using the images

Before you can use the images, you’ll need to add the login button text that you want to use. See [LINE Login button design guidelines][] for the recommended login button text for different langauges. You’ll also need to define stretchable regions of the image to add the button text without distorting the LINE icon.

1. Create [9-patch files][] for each image and define the stretchable regions for the login button text.
2. Add the button to the login screen of your app as a clickable text view with your desired login button text.
3. Add selector XML files in your drawable folders to define the image which corresponds to the state of the text view.

## Starting the login activity

When a user taps the login button, your app calls `getLoginIntent()` to get the login intent and start the login activity. The context and the Channel ID must be passed into this method. If the LINE app is installed on the device, the LINE app is opened to perform login without asking for the user’s LINE credentials. If the LINE app is not installed, users are redirected to the LINE Login screen in a browser to enter their LINE credentials (email address and password).

1. Set an on-click listener to listen for when the button is tapped.
1. In the `onClick` callback, call the `getLoginIntent()` method in `LineLoginApi` to get the login intent to start the login activity.
1. Start the authentication process by calling `startActivityForResult()` and passing the login intent and request code as parameters. The request code is an integer that is used to identify the request.

The following is an example of how to start the activity to log in the user when the user taps the login button.

```java
private static final int REQUEST_CODE = 1;
...
  
final TextView loginButton = (TextView) findViewById(R.id.login_button);
        loginButton.setOnClickListener(new View.OnClickListener() {
 
            public void onClick(View v) {
 
                try{
                    // App-to-app login
                    Intent loginIntent = LineLoginApi.getLoginIntent(v.getContext(), Constants.CHANNEL_ID);
                    startActivityForResult(loginIntent, REQUEST_CODE);
 
                }
                catch(Exception e) {
                    Log.e("ERROR", e.toString());
                }
            }
        });
```

Note: If you do not want to use app-to-app login and instead have the user log in via the LINE Login screen in a browser, use the `getLoginIntentWithoutLineAppAuth()` method.

## Handling the login result

After the user has logged in, the login result is returned in the activity’s `onActivityResult()` method. Your application must override this method to handle the login result.

Use the `getResponseCode()` method in the `LineLoginResult` object to determine if the login was successful. If `getResponseCode()` returns `SUCCESS`, the login was successful. Any other value indicates a failure. You can determine the type of error that occurred based on the response codes below.

| Response code  | Description                                                                   |
|----------------|-------------------------------------------------------------------------------|
| SUCCESS        | The login was successful.                                                     |
| CANCEL         | The login failed because the user canceled the login process.                 |
| SERVER_ERROR   | The login failed due to a server-side error.                                  |
| NETWORK_ERROR  | The login failed because the SDK could not connect to the LINE Platform.      |
| INTERNAL_ERROR | The login failed due to an unknown error.                                     |

The following shows an example of how the login result can be handled by your app.

```java
public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (requestCode != REQUEST_CODE) {
        Log.e("ERROR", "Unsupported Request");
        return;
    }

    LineLoginResult result = LineLoginApi.getLoginResultFromIntent(data);

    switch (result.getResponseCode()) {

        case SUCCESS:     
        // Login successful

            String accessToken = result.getLineCredential().getAccessToken().getAccessToken();

            Intent transitionIntent = new Intent(this, PostLoginActivity.class);
            transitionIntent.putExtra("line_profile", result.getLineProfile());
            transitionIntent.putExtra("line_credential", result.getLineCredential());
            startActivity(transitionIntent);
            break;

        case CANCEL:    
        // Login canceled by user
            Log.e("ERROR", "LINE Login Canceled by user!!");
            break;

        default:
        // Login canceled due to other error
            Log.e("ERROR", "Login FAILED!");
            Log.e("ERROR", result.getErrorData().toString());
    }
}
```

### Get access token

The login result contains a `LineCredential()` object which contains the user’s access token. As shown in the example above, you can retrieve the access token using the following code.

```java
String accessToken = result.getLineCredential().getAccessToken().getAccessToken();
```

### Get user profile immediately after login

The LINE SDK automatically gets a user’s profile information upon logging in. The user’s profile information consists of the display name, user ID, status message, and profile media. Access this information by calling the `getLineProfile` method in the `LineLoginResult` object. The following code snippet from the example above demonstrates how to get a user’s profile information from the login result and pass it into an intent.

```java
Intent transitionIntent = new Intent(this, PostLoginActivity.cla
transitionIntent.putExtra("display_name", result.getLineProfile().getDisplayName());
transitionIntent.putExtra("status_message", result.getLineProfile().getStatusMessage());
transitionIntent.putExtra("user_id", result.getLineProfile().getUserId());
transitionIntent.putExtra("picture_url", result.getLineProfile().getPictureUrl().toString
```

## Using the `LineApiClient` interface

APIs are called through the `LineApiClient` interface. To configure your app to call APIs, you must create a static variable of the `lineApiClient` object and initialize the variable.

1. Create a static variable of the object to call various methods.  

```java
private static LineApiClient lineApiClient;
```

2. Initialize the `lineApiClient` variable on your activity’s `onCreate()` method as shown below. The Channel ID and the context are required for initialization.  

```java
LineApiClientBuilder apiClientBuilder = new LineApiClientBuilder(getApplicationContext(), );
lineApiClient = apiClientBuilder.build();
```

Note: All of the APIs in the Android SDK perform network operations and will cause `NetworkOnMainThreadExceptions` if called on the main thread. To avoid this issue, call the APIs using `AsyncTask`.

## Next steps

You have now added LINE Login to your Android app. Users can log in to your app using their existing LINE accounts while your app can retrieve an access token and user profile information. For more information about the Android SDK, see the following pages.

- [Logging out users][]
- [Getting user profiles][]
- [Managing access tokens][]
- [Android SDK reference][]

<!-- reference Links -->
[android overview]: /android-overview
[try LINE Login]: /android-using-starter-app