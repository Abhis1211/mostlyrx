
package com.logixcess.mostlyrx;

import android.content.Context
import com.onesignal.OSNotificationReceivedEvent
import com.onesignal.OneSignal
import android.app.Notification
import android.R
import androidx.core.app.NotificationCompat

class NotificationServiceExtension : OneSignal.OSRemoteNotificationReceivedHandler {
    override fun remoteNotificationReceived( context: Context,notificationReceivedEvent: OSNotificationReceivedEvent
    ) {
        val notification = notificationReceivedEvent.notification
        val mutableNotification = notification.mutableCopy()
        notificationReceivedEvent.complete(mutableNotification)
    }
}