/*!
 * Copyright (c) 2014 Tommy-Carlos Williams. All rights reserved.
 * Copyright 2016 Ayogo Health Inc.
 */
package com.ayogo.privacyscreen;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import android.app.Activity;
import android.view.Window;
import android.view.WindowManager;
import android.os.Build;

/**
 * This class sets the FLAG_SECURE flag on the window to make the app private
 * when shown in the task switcher, if the NoAppScreenshots preference is set in
 * config.xml.
 */
public class PrivacyScreenPlugin extends CordovaPlugin {

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
    if (android.os.Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
      Activity activity = this.cordova.getActivity();
      activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
    }
  }

  @Override
  public void onResume(boolean multitasking) {
    if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      this.cordova.getActivity().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
    }
    super.onResume(multitasking);
  }

  @Override
  public void onPause(boolean multitasking) {
    if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      this.cordova.getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
    }
    super.onPause(multitasking);
  }
}
