/*
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
*/
package com.sap.walton.engineExt;

import android.net.http.SslError;
import android.webkit.ValueCallback;
import android.webkit.WebResourceResponse;

import org.crosswalk.engine.XWalkWebViewEngine;
import org.xwalk.core.XWalkView;
import org.crosswalk.engine.XWalkCordovaResourceClient;


public class XWalkCordovaResourceClientExt extends XWalkCordovaResourceClient {

	private static final String TAG = "XWalkCordovaResourceClientExt";

    public XWalkCordovaResourceClientExt(XWalkWebViewEngine parentEngine) {
        super(parentEngine);
    }

    /**
    * Report an error to the host application. These errors are unrecoverable (i.e. the main resource is unavailable).
    * The errorCode parameter corresponds to one of the ERROR_* constants.
    *
    * @param view          The WebView that is initiating the callback.
    * @param errorCode     The error code corresponding to an ERROR_* value.
    * @param description   A String describing the error.
    * @param failingUrl    The url that failed to load.
    */
    @Override
    public void onReceivedLoadError(XWalkView view, int errorCode, String description,
           String failingUrl) {
        super.onReceivedLoadError(view, errorCode, description, failingUrl);
    }

    @Override
    public WebResourceResponse shouldInterceptLoadRequest(XWalkView view, String url) {
        return super.shouldInterceptLoadRequest(view, url);
    }

    @Override
    public boolean shouldOverrideUrlLoading(XWalkView view, String url) {
        return super.shouldOverrideUrlLoading(view, url);
    }

    @Override
    public void onReceivedSslError(XWalkView view, ValueCallback<Boolean> callback, SslError error) {
        callback.onReceiveValue(true);
//        super.onReceivedSslError(view, callback, error);
    }
}
