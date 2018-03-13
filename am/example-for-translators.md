<!-- This is an example Markdown file for translators. -->

<!-- This is an example of a comment. Comments do not need to be translated -->

<!-- At the top of the page, we have the "front matter" written in YAML (a markup language). The front matter section is enclosed with 3 dashes.  The value for the "title" and "description" fields should be translated. All other fields do not need to be translated. The "keys" themselves ("title", "description") do not need to be translated. -->

---
title: Example file for translators
description: This article articulates our requirements for translation.
last-updated: 17-06-28
tags: translation, bots
---

<!-- Headings are indicated by the hashtag symbol (#). The number of # symbols correspond to the heading level. These symbols can be ignored in XTM. -->

# This is heading 1

## This is heading 2

To implement your bot, run this sample code.

<!-- These are 2 examples of code blocks. These are not to be translated and should be left as-is. The indents and spacing must be preserved in code blocks -->

```java
String accessToken = result.getLineCredential().getAccessToken().getAccessToken();
```

```objc
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [[LineSDKLogin sharedInstance] handleOpenURL:url];
}
```

## Ignore inline code elements

<!-- This is example syntax of inline code elements. Do not translate these elements. -->

Login is started by calling the `startLogin` method. The application behaves as follows when `startLogin` is called.

## Links and link text

<!-- Example of link text and URL. The URL can be ignored. -->

For more information, go to [Google](https://google.com).

<!-- Example of link text using reference link syntax -->

For more information, go to [Google. This is link text that needs to be translated][google-site].

<!-- Reference link at the bottom of the page. Do not translate these links. -->

[google-site]: https://google.com

## Images

<!-- This is the syntax for images. Only the image alt text should be translated. Ignore the exclamation point, brackets, and URL. -->

![Image alt text](/images/jekyll.png)

