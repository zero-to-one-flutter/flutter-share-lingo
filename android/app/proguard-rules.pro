# TensorFlow Lite core
-keep class org.tensorflow.** { *; }
-keep class org.tensorflow.lite.** { *; }

# TensorFlow Lite GPU delegates
-keep class org.tensorflow.lite.gpu.** { *; }
-dontwarn org.tensorflow.lite.gpu.**

# If using NNAPI or Hexagon delegates
-keep class org.tensorflow.lite.nnapi.** { *; }
-dontwarn org.tensorflow.lite.nnapi.**
-keep class org.tensorflow.lite.hexagon.** { *; }
-dontwarn org.tensorflow.lite.hexagon.**
