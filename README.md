# deprecated

#### Table of Contents

1. [Description](#description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module provides a mechanism for softly deprecating Puppet class parameters, such that old parameters may still be used for a period of time and alert users of what changes they need to make to update their code, before the deprecated parameters become fully obsolete in some future release.

The module provides tools to do this in a way that makes it obvious to code developers and to end users that deprecation is occuring.

## Usage

See the [`deprecated::example`](manifests/example.pp) class for basic usage.

### Deprecated parameter with no replacement

Original class:

```diff
class example (
  String $api_v1 = '123',
) {

  notify { 'example':
    message => $api_v1,
  }
}
```

Deprecating the `api_v1` parameter:

```diff
 class example (
-  String $api_v1 = '123',
+  String $api_v1 = 'not user configurable anymore',
 ) {
+  deprecated::parameters({
+    'api_v1' => { },
+  })

   notify { 'example':
     message => $api_v1,
   }
 }
```

Obsoleting the `api_v1` parameter:

```diff
 class example (
-  String $api_v1 = 'not user configurable anymore',
 ) {
-  deprecated::parameters({
-    'api_v1' => { },
-  })

   notify { 'example':
-    message => $api_v1,
+    message => 'not user configurable anymore',
   }
 }
```

### Deprecated parameter with a replacement

Original class:

```diff
 class example (
   String $api_v1 = '123',
 ) {

   notify { 'example':
     message => $api_v1,
   }
 }
```

Deprecating the `api_v1` parameter in favor of `api_v2`:

```diff
 class example (
-  String $api_v1 = '123',
+  Variant[String, Deprecated::Param] $api_v1 = deprecated::param(),
+  String $api_v2 = deprecated::backwards_compatible_default($api_v1, 'api_v2 default'),
 ) {
+  deprecated::parameters({
+    'api_v1' => { replacement => 'api_v2' },
+  })

   notify { 'example':
     message => $api_v2,
   }
 }
```

Obsoleting the `api_v1` parameter:

```diff
 class example (
-  Variant[String, Deprecated::Param] $api_v1 = deprecated::param(),
-  String $api_v2 = deprecated::backwards_compatible_default($api_v1, 'api_v2 default'),
+  String $api_v2 = 'api_v2 default',
 ) {
-  deprecated::parameters({
-    'api_v1' => { replacement => 'api_v2' },
-  })

   notify { 'example':
     message => $api_v2,
   }
 }
```
